require 'spec_helper'
require 'tempfile'


describe 'SudoTool::SudoerFile' do
    before :each do
      
      # Create the test file
      @test_file = Tempfile.new 'sudotest'
      file_contents = <<EOF
#
# This file is maintained by the sudotool script and should not be
# edited directly.
#
# version        : 1.0
# expires        : 2013-10-26T04:00:20-0700
#

# --Begin Rights--

bob             ALL = (ALL) ALL
alice           ALL = (ALL) ALL
zack            ALL = (ALL) ALL
%opers          ALL = (ALL) ALL
+dev            ALL = (ALL) ALL

# --End Rights--
EOF
      
      @test_file.write file_contents
      @test_file.close
    end


    after :each do
      @test_file.unlink
    end
  
    describe '#read' do
      
      it 'finds rights for user bob' do
        @convert = SudoTool::SudoerFile.new @test_file.path
        @convert.rights.should include SudoTool::SudoRight.new('bob')
      end
      
      it 'finds 5 rights' do
        @convert = SudoTool::SudoerFile.new @test_file.path
        @convert.rights.should have(5).items
      end
      
      it 'accepts rights specified for a netgroup' do
        @undertest = SudoTool::SudoerFile.new @test_file.path
        @undertest.rights.should include SudoTool::SudoRight.new('%opers')
      end
      
      it 'accepts rights specified for a group' do
        @undertest = SudoTool::SudoerFile.new @test_file.path
        @undertest.rights.should include SudoTool::SudoRight.new('+dev')
      end
    
    end
  
    
    describe '#write' do
      
      it 'creates a file with permissions of 0440' do
        @convert = SudoTool::SudoerFile.new @test_file.path
        @convert.add_right SudoTool::SudoRight.new 'gene'
        @convert.write
        
        mode = File.stat(@test_file.path).mode
        mode.should == 33056
        
      end
      
      
    end
    
end



## # sudoers file.
## #
## # This file MUST be edited with the 'visudo' command as root.
## 
## # Host alias specification
## 
## # User alias specification
## 
## # Runas alias specification
## 
## # Cmnd alias specification
## 
## # User privilege specification
## root            ALL=(ALL) ALL
## +sun            ALL=(ALL) ALL
## +dba            ALL=/usr/bin/su - oracle
## +unixcore       ALL=(ALL) ALL
## +mit            ALL=(ALL) ALL
## +admins         ALL=(ALL) ALL
## +batch          ALL=(ALL) ALL
## +opers          ALL=(ALL) ALL
## +san ALL=(ALL) ALL
## +build ALL=(ALL) ALL