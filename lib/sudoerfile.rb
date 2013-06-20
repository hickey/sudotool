
require 'time'

require 'sudoright'



class Sudoerfile 
  
  def initialize(filename)
    @filename = filename
    @managed= false
    @file_read = false
    @attrib = { :version => '1.0',
                :expires => DateTime.now + 7 }
    
    @rights = @hostgrps = @cmdgrps = []
    
    if is_locked?
      readLockedFile
    else
      read
    end
  end
  
  
  def read
    # Setup a number of convenient regex for parsing
    RE_attrline  = Regexp.new %r{^#\s+(?<key>\w+)\s*:\s*(?<value>.+)\s*$}
    RE_rightline = Regexp.new %r{^(?<user>\w+)\s+(?<hostgrp>\w+)\s*=\s*\((?<runas>\w+)\)\s?(?<cmd>.+)$}
    
    # Nothing to read here... Move along....
    if not File.exist? @filename
      return
    end
    
    File.open(@filename, 'r') do |fp|
      while line = fp.gets
        RE_attrline.match(line) do |match|
          if match[:key] == :expires.to_s
            ex_date = DateTime.strptime(match[:value], '%Y-%m-%dT%H:%M:%S')
            @attrib[:expires] = ex_date
            
            # if there is an expires attribute consider this file managed
            @managed = true
          else
            @attrib[match[key.to_sym]] = match.value
          end
          next
        end
        
        RE_rightline.match(line) do |match|
          right = SudoRight.new match[:user]
          right.setHostgrp match[:hostgrp]
          right.setRunas match[:runas]
          right.setCmd match[:cmd]
          addRight right
        end
      end
      
      @file_read = true
    end
  end
  
  
  def read_locked_file
    unlock_file
    read
    lock_file
  end
  
  
  
  def write 
    if @file_read and not managed?
      return
    end
    if is_locked?
      puts "Unable to write to locked file: #{@filename}"
      return
    end
    
    # set the file to writable and write it
    if File.exist? @filename
      File.chmod(0600, @filename)
    end
    File.open(@filename, 'w') do |fp|
      fp.write(self.to_s)
    end
    # set the proper ownership and permissions
    begin
      File.chown(0, 0, @filename)
    rescue Exception => e
      if Process.euid != 0
        puts "Warning: non root user can not set ownership of file."
      else
        puts "Exception while setting ownership to root: #{e.message}"
      end
    end
    File.chmod(0440, @filename)
  end
  
  
  # Add the supplied SudoRight object to the list of rights to include
  # into the sudoers file. If a duplicate right exists, exit without
  # adding to the list of rights
  # Params:
  # +right+:: SudoRight object
  def add_right(right)
    unless @rights.member? right
      @rights << right
    end
  end
  
  
  def del_right(right)
    nil
  end
  
  
  # Remove the rights for the indicated user.
  # Params:
  # +user+:: username
  def del_right_for_user(user)
    @rights = @rights.collect {|r| r.user != user}
  end
  
  # Return the currently set expiration time as a DateTime object
  def expiration
    @attrib[:expires]
  end
  
  def expiration=(date_obj)
    @attrib[:expires] = date_obj
  end
  
  
  # If the sudoers file has been detected as a managed file, return true. 
  # Otherwise consider it a regular file and return false.
  def managed?
    @managed
  end
  
  
  # Check the expiration header to see if file has expired
  def is_expired?
    if not managed?
      return false
    else
      return expiration < DateTime.now
    end
  end
  
  
  # Check the permissions on the file and indicate if the file is locked.
  def is_locked?
    if not File.exist? @filename
      return false
    else
      return (File.stat(@file).mode & 0777) == 0000
    end
  end
  
  
  # Set the file so that no one may read the file. The result is that
  # the sudoers file has all permissions removed from it.
  def lock_file
    File.chmod(0000, @filename)
  end
  
  
  # Set the file so that only the owner may read the file.
  def unlock_file
    File.chmod(0400, @filename)
  end
  
  
  # Return the constructed sudoers file
  def to_s
    contents = <-EOH
#
# This file is maintained by the sudotool script and should not be 
# edited directly.
#
EOH

    # Create a table of the attributes for this file
    @attrib.keys.each do |key|
      if key == :expires
        contents += "# %-15s: %s\n" % [key.to_s, @attrib[key].strftime('%Y-%m-%dT%H:%M:%S%z')]
      else 
        contents += "# %-15s: %s\n" % [key.to_s, @attrib[key]]
      end
    end
    contents += "#\n\n"
   
    # write out the host groups
    unless @hostgrps.empty? 
      contents += "# --Begin Host Aliases\n\n"
      @hostgrps.each {|group|  contents += group.to_s }
      contents += "\n# --End Host Aliases--\n\n\n"
    end
   
    # write out the command groups
    unless @cmdgrps.empty?
      contents += "# --Begin Command Aliases\n\n"
      @cmdgrps.each {|group|  contents += group.to_s } 
      contents += "\n# --End Command Aliases--\n\n\n"
    end

    # Write out the user rights
    unless @rights.empty?
      contents += "# --Begin Rights\n\n"
      @rights.each {|right|  contents += right.to_s }
      contents += "\n# --End Rights--\n"
    end
    
    return contents
  end
end
