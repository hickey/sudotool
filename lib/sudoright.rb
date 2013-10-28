

module SudoTool
  class SudoRight
  
    attr_reader   :user
    attr_writer   :hostgrp, :runas, :cmd

    
    # Create an instance of SudoRight
    # Params:
    # +user+:: Username to create the right for
    def initialize(user)
      @user = user
      @hostgrp = 'ALL'
      @runas = 'ALL'
      @cmd = 'ALL'
      
      # Allow chaining of methods
      self
    end
    
    
    def self.parse(entry)
      match = entry.match %r{^\s*([\w+%]:?\w+)\s+(\w+)\s*=\s*(?:\((\w+)\))?\s*(.+?)\s*$}
      if match.nil?
        return nil
      end
      
      # Build up a right object and return it. 
      right = SudoTool::SudoRight.new match[1]
      right.hostgrp = match[2]
      right.runas = match[3]
      right.cmd = match[4]
      return right
    end
    
    
    def to_s
      if @runas.nil?
        return "%-15s %s = %s" % [user, hostgrp, cmd]
      else
        return "%-15s %s = (%s) %s" % [user, hostgrp, runas, cmd]
      end
    end
    
    
    # Compare this object to another object and return if they are equivilent
    def ==(other)
      if user == other.user and hostgrp == other.hostgrp and runas == other.runas and cmd == other.cmd
        return true
      else
        return false
      end
    end
    

    # create some dynamic property methods to allow chaining
    [:hostgrp, :runas, :cmd].each do |property|
      eval <<-EOM
        def #{property}(value=nil)
          if value.nil?
            return @#{property}
          elsif value.empty?
            unless "#{property}" == 'cmd'
              # Not a valid setting so leave alone
              return self
            end
            raise ArgumentError, "Must specify commands/cmnd_alias when adding user"
          else
            @#{property} = value
            return self
          end
        end
      EOM
    end
    

  end
end