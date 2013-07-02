require 'spec_helper'

describe Review do
  let (:review) { FactoryGirl.create :review }

  describe "saving" do
    it "is possible" do
      review
      Review.first.should == review
    end
  end

  it { should validate_presence_of(:things_i_like) }
  it { should validate_presence_of(:things_to_improve) }
  it { should validate_presence_of(:presenter) }
  it { should validate_presence_of(:session) }
  it { should validate_presence_of(:score) }
  it { should validate_numericality_of(:score) }

  describe "relation things to improve and score" do
    it "things to improve has to be empty when score is 10" do
      review.score = '10'
      review.things_to_improve = 'something to improve'
      review.should be_invalid
    end
    it "things to improve has to be filled when score is lower than 10" do
      review.score = '9'
      review.things_to_improve = ''
      review.should be_invalid
    end
  end

end
