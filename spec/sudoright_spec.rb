require 'spec_helper'


describe 'SudoTool::SudoRight' do
  before :each do
    @right = SudoTool::SudoRight.new 'bob'
  end
  
  
  it 'gives user bob all sudo rights' do
    @right.to_s.should eql "%-15s ALL = (ALL) ALL" % 'bob'
  end
  
  describe '#==' do 
    it 'verifies that an object equals itself' do
      @right.should == SudoTool::SudoRight.new('bob')
    end 
    
    it 'verifys that two different objects are not the same' do
      @right.should_not == SudoTool::SudoRight.new('BOB')
    end
  end
  
  
  describe '::parse' do
    it 'parses user with full rights' do
      check = SudoTool::SudoRight.parse('bob   ALL=(ALL)ALL')
      @right.should == check
    end
    
    it 'parses user with odd spacing' do
      check = SudoTool::SudoRight.parse('bob             ALL =(ALL)     ALL')
      @right.should == check
    end
    
    it 'access initial spaces before right' do
      check = SudoTool::SudoRight.parse('  bob     ALL = (ALL) ALL')
      @right.should == check
    end
    
    it 'strips whitespace from the end of the command' do 
      check = SudoTool::SudoRight.parse('bob     ALL = (ALL) ALL   ')
      @right.should == check
    end
    
    
    describe '::new' do
      it 'supports chaining of hostgrp' do 
        check = SudoTool::SudoRight::parse('bob   devboxes=(ALL) ALL')
        @undertest = SudoTool::SudoRight.new('bob').hostgrp('devboxes')
        @undertest.should == check
      end
    
      it 'supports chaining of runas' do 
        check = SudoTool::SudoRight::parse('bob   ALL=(bin) ALL')
        @undertest = SudoTool::SudoRight.new('bob').runas('bin')
        @undertest.should == check
      end
      
      it 'supports chaining of cmd' do 
        check = SudoTool::SudoRight::parse('bob   ALL=(ALL) /bin/ls')
        @undertest = SudoTool::SudoRight.new('bob').cmd('/bin/ls')
        @undertest.should == check
      end
      
      it 'supports chaining of all attributes' do 
        check = SudoTool::SudoRight::parse('bob   devboxes=(bin) /bin/ls')
        @undertest = SudoTool::SudoRight.new('bob')
                        .hostgrp('devboxes').runas('bin').cmd('/bin/ls')
        @undertest.should == check
      end
    end
    
  end
  
end
