require 'spec_helper'

describe PropileConfig do

  describe "is_set" do
    it "is false if it does not exist" do
      PropileConfig.is_set("nothing_set").should == false
    end
    it "is false if it exists but it is not true" do
      PropileConfig.new(:name => "false_set", :value => "false" ).save
      PropileConfig.is_set("false_set").should == false
    end
    it "is true if it exists and it is set to true" do
      PropileConfig.new(:name => "true_set", :value => "true" ).save
      PropileConfig.is_set("true_set").should == true
    end
  end

end
