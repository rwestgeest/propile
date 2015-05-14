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
  it { should validate_numericality_of(:xp_factor) }
  it { [-1, 11].each { |n| should_not allow_value(n).for(:xp_factor) } }

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

  describe "filled?" do
    it "returns false if no fields are filled" do
      empty_review = FactoryGirl.build :review, things_i_like: nil, things_to_improve: nil, score: nil
      empty_review.should_not be_filled
    end
    it "returns false if all fields are empty" do
      empty_review = FactoryGirl.build :review, things_i_like: "", things_to_improve: "", score: nil
      empty_review.should_not be_filled
    end
    it "returns true if no things_i_like is filled" do
      filled_review = FactoryGirl.build :review, things_i_like: "YES", things_to_improve: nil, score: nil
      filled_review.should be_filled
    end
    it "returns true if no things_to_improve is filled" do
      filled_review = FactoryGirl.build :review, things_i_like: nil, things_to_improve: "YES", score: nil
      filled_review.should be_filled
    end
    it "returns true if no score is filled" do
      filled_review = FactoryGirl.build :review, things_i_like: nil, things_to_improve: nil, score: 5
      filled_review.should be_filled
    end
  end
end
