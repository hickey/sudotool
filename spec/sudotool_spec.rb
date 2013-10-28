require 'spec_helper'
require 'time'

describe 'SudoTool' do
  
  before :all do
    if File.directory? 'tests'
      Dir.open('tests').each {|f| 
        unless f == '.' or f == '..'
          File.unlink "tests/#{f}"
          end
      }
      Dir.rmdir 'tests'
    end
  end
  
  
  describe '#pretty_time_to_real_time' do
    it 'returns tomowrrows date' do
      tomorrow = Time.now + 86400
      SudoTool::pretty_time_to_real_time('1d').to_s.should eql tomorrow.to_s
    end
    
    it 'returns date in 3 weeks' do
      tomorrow = Time.now + (3 * 7 * 86400)
      SudoTool::pretty_time_to_real_time('3w').to_s.should eql tomorrow.to_s
    end
    
    it 'returns date in 2 months' do
      tomorrow = Time.now + (2 * 4 * 7 * 86400)
      SudoTool::pretty_time_to_real_time('2m').to_s.should eql tomorrow.to_s
    end
    
    it 'returns date in 6 years' do
      tomorrow = Time.now + (6 * 365 * 86400)
      SudoTool::pretty_time_to_real_time('6y').to_s.should eql tomorrow.to_s
    end
    
    it 'returns time in 12 hours' do
      tomorrow = Time.now + (12 * 3600)
      SudoTool::pretty_time_to_real_time('12h').to_s.should eql tomorrow.to_s
    end
    
    it 'correctly calculates January 1' do
      now = DateTime.now
      target = DateTime.new(now.year, 1, 1)
      if target < now
        target = DateTime.new(now.year + 1, 1, 1)
      end
      SudoTool::pretty_time_to_real_time('1/1').to_s.should eql target.to_s
    end
    
    it 'correctly calculates 6/15/2014' do
      target = DateTime.new(2014, 6, 15)
      SudoTool::pretty_time_to_real_time('6/15/2014').to_s.should eql target.to_s
    end
      
    it 'passes never as a valid time' do 
      SudoTool::pretty_time_to_real_time('never').should eql :never
    end
    
  end
  
  
  describe '#purge' do
    it 'only locks files that have expired' do
      SudoTool::purge(nil, 'tests')
      
      # file2 should now be locked
      @file1.is_locked?.should eql false
      @file2.is_locked?.should eql true
    end
    
    
    before :each do
      Dir.mkdir 'tests'
      
      @file1 = SudoTool::SudoerFile.new "tests/file1"
      @file1.expiration = DateTime.now + 3
      @file1.write
      
      @file2 = SudoTool::SudoerFile.new "tests/file2"
      @file2.expiration = DateTime.now - 1
      @file2.write
    end
    
    after :all do
      if File.directory? 'tests'
        Dir.open('tests').each {|f| 
          unless f == '.' or f == '..'
            File.unlink "tests/#{f}"
            end
        }
        Dir.rmdir 'tests'
      end
    end
  end
  
end