require 'spec_helper'

describe Review do
  describe "saving" do
    it "is possible" do
      review = FactoryGirl.create :review
      Review.first.should == review
    end
  end

  it { should validate_presence_of(:things_i_like) }
  it { should validate_presence_of(:things_to_improve) }
  it { should validate_presence_of(:presenter) }
  it { should validate_presence_of(:session) }
end
