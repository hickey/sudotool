require 'spec_helper'


describe 'SudoTool::SudoRight' do
  before :each do
    @right = SudoTool::SudoRight.new 'bob'
  end
  
  
  it 'gives user bob all sudo rights' do
    @right.to_s.should eql "%-15s ALL = (ALL) ALL" % 'bob'
  end
  
end
