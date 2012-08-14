require 'spec_helper'

describe Vote do
  describe "saving" do
    it "is possible" do
      vote = FactoryGirl.create :vote
      Vote.first.should == vote
    end
  end

  it { should validate_presence_of(:presenter) }
  it { should validate_presence_of(:session) }
end
