
require 'sudogroup'

module SudoTool
  class SudoCmdAlias < SudoGroup
    
    def initialize(name)
      super(name)
      @alias_type = 'Cmnd_Alias'
    end
    
    
  end
end
