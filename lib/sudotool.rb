
require 'sudoerfile'

require 'rubygems'
require 'time'
require 'log4r'
include Log4r



module SudoTool
  
  VERSION = '1.1.0'
  
  module_function
  
  # Take a human readable time delta (e.g. 3w, 28d, or 150h) or specific 
  # time (e.g. 5/21, or 6/13/2013) and convert to a datetime object. The 
  # accepted suffixes are h(hour), d(day), w(week), m(month), y(year). 
  # Complex deltas such as 3w4d are not supported at this time. The 
  # specific time format can accept dash(-), slash(/) or a period(.) as
  # a seperator. Special case: if the word never, NEVER or Never is 
  # specified in the timespec parameter, then return the symbol :never.
  # Params:
  # +timespec+: human readable time delta or specific time
  def pretty_time_to_real_time(timespec)
    # record the current time to make time comparisons
    now = Time.now
    
    # Unfortunately 1.8.7 does not have named captures :-(
    match = %r{^(\d{1,2})[-\/.](\d{1,2})[-\/.]?(\d{2,4})?$}.match(timespec) 
    unless match.nil?
      if match[3].nil?
        # year was not specified, better calculate it
        year = now.year
        
        # lets fake the number of days in the the year for both dates
        days_now = now.month * 32 + now.day
        days_spec = match[1].to_i * 32 + match[2].to_i
        if days_spec < days_now
          # Specification is for a day before today
          year += 1
        end
      else 
        year = match[3].to_i
      end
      
      return DateTime.new(year, match[1].to_i, match[2].to_i)
    end
    
    match = %r{^(\d+)([hdwmy])$}.match(timespec) 
    unless match.nil?
      # Time delta specification
      days = hours = 0
      quan = match[1].to_i
      case match[2]
      when 'h'
        hours = quan
      when 'd'
        days = quan
      when 'w'
        days = quan * 7
      when 'm'
        days = quan * 7 * 4
      when 'y'
        days = quan * 365
      end
      delta = (days * 86400) + (hours * 3600)
      return (now + delta)
    end
 
    # Special case: never
    if ['never', 'Never', 'NEVER'].member? timespec
      return :never
    end
    
    # if we get here then we have an unrecognized format
    raise ArgumentError, "Time specification not recognized: #{timespec}"
  end



  def purge(logfile=nil, basedir='/etc/sudoers.d')
    # setup logging to keep an audit trail
    log = Logger.new('sudotool')
    if logfile.nil?
      outputter = Outputter.stdout
      outputter.formatter = SimpleFormatter.new
      log.outputters << outputter
    else
      file = FileOutputter.new(logfile, :filename => logfile)
      file.formatter = PatternFormatter.new(:pattern => '%d [%c] %l: %M',
                                            :date_pattern => '%Y-%m-%d %H:%M:%S')
      log.outputters << file
    end
      
    # check all the files in the basedir for anything that may have expired
    old_dir = Dir.pwd
    begin
      Dir.chdir basedir
    rescue Errno::ENOENT => e
      $stderr.puts "Error: #{basedir} does not exist as a directory"
      exit 1
    end
    
    Dir.open('.').each do |entry|
      if File.file? entry
        log.debug "Processing #{entry}"
        begin
          sudofile = SudoerFile.new entry
        rescue Exception => e
          log.error "Critical error reading #{entry}: #{e.message}"
          next
        end
        
        if sudofile.is_locked?
          log.debug "#{entry} is already locked; skipping"
        elsif sudofile.is_expired?
          log.info "#{entry} has expired; Locking file"
          sudofile.lock_file
        end
      end
    end
    
    Dir.chdir old_dir
  end
  


end
