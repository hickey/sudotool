require 'spec_helper'


describe SudoTool::SudoGroup do
  before :each do
    @group = SudoTool::SudoGroup.new "Group"
  end
  
  describe '#new' do
    it 'takes a name paramter and returns a SudoGroup object' do
      @group.should be_an_instance_of SudoTool::SudoGroup
    end
  end
  
  describe '#name' do
    it 'returns the correct group name' do
      @group.name.should eql 'Group'
    end
    
    it 'should fail on trying to reset the name' do
      @group.should_not respond_to(:name=)
    end
  end
  
  
  describe '#items' do
    it 'returns no items' do
      @group.items.should have(0).items
    end
  
    it 'returns 6 items' do
      @group.items << 'item1'
      @group.items << 'item2'
      @group.items << 'item3'
      @group.items << 'item4'
      @group.items << 'item5'
      @group.items << 'item6'
      @group.items.should have(6).items
    end
  end
  
  
  describe '#alias_type' do 
    it 'returns an Unknown alias type' do
      @group.alias_type.should eql 'Unknown'
    end
    
    it 'should fail on trying to set the alias type' do
      @group.should_not respond_to(:alias_type=)
    end
  end
  
  
  describe '#==' do
    it 'equals an empty object' do
      other = SudoTool::SudoGroup.new 'Group'
      @group.should == other
    end
    
    it 'not equal to non empty object' do
      other = SudoTool::SudoGroup.new 'Group'
      other.items << 'item1'
      other.items << 'item2'
      @group.should_not == other
    end
    
    it 'not equal object by another name' do
      other = SudoTool::SudoGroup.new 'Other Name'
      @group.should_not == other
    end
  end

end