
require 'sudogroup'

module SudoTool
  class SudoHostAlias < SudoGroup
    
    def initialize(name)
      super(name)
      @alias_type = 'Cmnd_Alias'
    end
    
    
  end
end
