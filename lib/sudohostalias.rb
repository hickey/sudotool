
require 'sudogroup'

module SudoTool
  class SudoHostAlias < SudoGroup
    
    def initialize(name)
      super(name)
      @alias_type = 'Host_Alias'
    end
    
    
  end
end
