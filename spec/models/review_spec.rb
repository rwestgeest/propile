require 'spec_helper'

describe Review do
  describe "saving" do
    it "is possible" do
      review = FactoryGirl.create :review
      Review.first.should == review
    end
  end

  it { should validate_presence_of(:body) }

end
