require 'spec_helper'

describe StatisticsHelper do
  include StatisticsHelper

  let(:session)  { FactoryGirl.create :session_with_presenter }
  let(:presenter)  { FactoryGirl.create :presenter }
  let(:review)  { FactoryGirl.create :review }

  describe "get_review_statistics" do
    it "returns something for an empty application" do
      get_review_statistics.should_not be_nil
    end
    describe "total_number_of_sessions" do
      it "returns 0 if no sessions are defined " do
        get_review_statistics.total_number_of_sessions.should == 0
      end
      it "returns 1 if a session is defined " do
        session
        get_review_statistics.total_number_of_sessions.should == 1
      end
    end
    describe "total_number_of_presenters" do
      it "returns 0 if no presenters are defined " do
        get_review_statistics.total_number_of_presenters.should == 0
      end
      it "returns 1 if a presenter is defined " do
        presenter
        get_review_statistics.total_number_of_presenters.should == 1
      end
    end
    describe "total_number_of_reviews" do
      it "returns 0 if no reviews are defined " do
        get_review_statistics.total_number_of_reviews.should == 0
      end
      it "returns 1 if a review is defined " do
        review
        get_review_statistics.total_number_of_reviews.should == 1
      end
    end
    describe "total_number_of_reviewers" do
      it "returns 0 if no reviews are defined " do
        get_review_statistics.total_number_of_reviewers.should == 0
      end
      it "returns 1 if a review is defined " do
        review
        get_review_statistics.total_number_of_reviewers.should == 1
      end
    end
    describe "number_of_sessions_reviewed" do
      it "returns 0 if no reviews are defined " do
        get_review_statistics.number_of_sessions_reviewed.should == 0
      end
      it "returns 1 if a review is defined " do
        review
        get_review_statistics.number_of_sessions_reviewed.should == 1
      end
    end
    describe "percentage_of_sessions_reviewed" do
      it "returns 100 if no reviews are defined " do
        get_review_statistics.percentage_of_sessions_reviewed.should == 100
      end
      it "returns 100 if 1 session exists and it is reviewed " do
        review
        get_review_statistics.percentage_of_sessions_reviewed.should == 100
      end
      it "returns 50 if 2 sessions exist and only 1 is reviewed " do
        review
        session
        get_review_statistics.percentage_of_sessions_reviewed.should == 50
      end
    end
    describe "percentage_of_presenters_who_review" do
      it "returns 100 if no reviews are defined " do
        get_review_statistics.percentage_of_presenters_who_review.should == 100
      end
      it "returns 50 if 1 session exists and it is reviewed " do
        review
        get_review_statistics.total_number_of_presenters.should == 2 #1 presenter, 1 reviewer
        get_review_statistics.percentage_of_presenters_who_review.should == 50
      end
      it "returns 33 if 2 sessions exist and only 1 is reviewed " do
        review
        presenter
        get_review_statistics.total_number_of_presenters.should == 3 #1 presenter, 1 reviewer, 1 extra presenter
        get_review_statistics.percentage_of_presenters_who_review.should == 33
      end
    end
  end
  describe "number_of_reviews_by_presenters" do

  end
end
