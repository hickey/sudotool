require 'spec_helper'
require 'tempfile'


describe 'SudoTool::SudoConvert' do
  
  
  before :each do
    # Create the test file
    @test_file = Tempfile.new 'sudotest'
    file_contents = <<-EOF
# sudoers file.
#
# This file MUST be edited with the 'visudo' command as root.

# Host alias specification

# User alias specification

# Runas alias specification

# Cmnd alias specification

# User privilege specification
root            ALL=(ALL) ALL
+sun            ALL=(ALL) ALL
+dba            ALL=/usr/bin/su - oracle
+unixcore       ALL=(ALL) ALL
+mit            ALL=(ALL) ALL
+admins         ALL=(ALL) ALL
+batch          ALL=(ALL) ALL
+opers          ALL=(ALL) ALL
+san ALL=(ALL) ALL
+build ALL=(ALL) ALL
EOF
    @test_file.write file_contents
    @test_file.close
    
    @convert = SudoTool::SudoConvert.new @test_file.path
  end
  
  
  after :each do
    @test_file.unlink
  end
  
  
  it 'removes empty lines and lines containing comments' do
    @convert.sudofile.rights.should have(10).items
  end
  
  

  
end
