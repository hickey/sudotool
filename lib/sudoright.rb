

module SudoTool
  class SudoRight
  
    attr_reader   :user
    attr_accessor :hostgrp
    attr_accessor :runas
    attr_accessor :cmd
    
    # Create an instance of SudoRight
    # Params:
    # +user+:: Username to create the right for
    def initialize(user)
      @user = user
      @hostgrp = 'ALL'
      @runas = 'ALL'
      @cmd = 'ALL'
    end
    
    
    def to_s
      "%-15s %s = (%s) %s\n" % [user, hostgrp, runas, cmd]
    end
    
    
    # Compare this object to another object and return if they are equivilent
    def ==(other)
      if user == other.user and hostgrp == other.hostgrp and runas == other.runas and cmd == other.cmd
        return true
      else
        return false
      end
    end
    
    
  end
end