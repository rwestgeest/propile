require 'spec_helper'

describe Comment do
  describe "saving" do
    it "is possible" do
      comment = FactoryGirl.create :comment
      Comment.first.should == comment
    end
  end

  it { should validate_presence_of(:body) }
#  it { should validate_presence_of(:review) }
#  it { should validate_presence_of(:presenter) }

end
