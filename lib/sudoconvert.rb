require 'sudoerfile'

require 'log4r'
include Log4r



module SudoTool
  
  class SudoConvert
    
    attr :sudofile
    
    def initialize(filename)
      # read in and process its contents
      @sudofile = SudoTool::SudoerFile.new filename

    end
    
    
 
  end
  
  
end