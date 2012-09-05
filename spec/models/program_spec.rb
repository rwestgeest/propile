require 'spec_helper'

describe Program do

  describe "saving" do
    it "is possible" do
      program = FactoryGirl.create :program
      Program.first.should == program
    end
  end
end
