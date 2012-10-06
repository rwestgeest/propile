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

  describe "set" do
    it "to true -> is_set will return true" do
      PropileConfig.set("set_it_now", "true")
      PropileConfig.is_set("set_it_now").should == true
    end
    it "to true for existing value -> is_set will return true" do
      PropileConfig.set("set_it_now", "true")
      PropileConfig.set("set_it_now", "true")
      PropileConfig.is_set("set_it_now").should == true
    end
    it "to true for existing value that was false-> is_set will return true" do
      PropileConfig.set("set_it_now", "false")
      PropileConfig.set("set_it_now", "true")
      PropileConfig.is_set("set_it_now").should == true
    end
    it "to false for existing value that was true-> is_set will return false" do
      PropileConfig.set("set_it_now", "true")
      PropileConfig.set("set_it_now", "false")
      PropileConfig.is_set("set_it_now").should == false
    end
  end

  describe "toggle" do
    context "value is not set" do
      it "toggle will set it to true" do
        PropileConfig.toggle("toggle_it_now")
        PropileConfig.is_set("toggle_it_now").should == true
      end
    end
    context "value is false" do
      it "toggle will set it to true" do
      PropileConfig.new(:name => "false_set", :value => "false" ).save
        PropileConfig.toggle("false_set")
        PropileConfig.is_set("false_set").should == true
      end
    end
    context "value is true" do
      it "toggle will set it to false" do
        PropileConfig.new(:name => "true_set", :value => "true" ).save
        PropileConfig.toggle("true_set")
        PropileConfig.is_set("true_set").should == false
      end
    end
  end

end
