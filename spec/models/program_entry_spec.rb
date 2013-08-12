require 'spec_helper'

describe ProgramEntry do
  describe "saving" do
    it "is possible" do
      program_entry =  FactoryGirl.create :program_entry 
      ProgramEntry.first.should == program_entry
    end
  end
end
