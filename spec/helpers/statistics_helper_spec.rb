require 'spec_helper'

describe StatisticsHelper do
  include StatisticsHelper

  let(:session)  { FactoryGirl.create :session_with_presenter }
  let(:presenter)  { FactoryGirl.create :presenter }
  let(:review)  { FactoryGirl.create :review }

  describe "get_base_statistics" do
    it "returns something for an empty application" do
      get_base_statistics.should_not be_nil
    end
    describe "total_number_of_sessions" do
      it "returns 0 if no sessions are defined " do
        get_base_statistics.total_number_of_sessions.should == 0
      end
      it "returns 1 if a session is defined " do
        session
        get_base_statistics.total_number_of_sessions.should == 1
      end
    end
    describe "total_number_of_presenters" do
      it "returns 0 if no presenters are defined " do
        get_base_statistics.total_number_of_presenters.should == 0
      end
      it "returns 1 if a presenter is defined " do
        presenter
        get_base_statistics.total_number_of_presenters.should == 1
      end
    end
    describe "percentage" do
      it "returns 100 if total==0" do
        get_base_statistics.percentage(10,0).should == 100
      end
      it "returns 0 if number==0" do
        get_base_statistics.percentage(0,10).should == 0
      end
      it "returns 100 if number==total " do
        get_base_statistics.percentage(10,10).should == 100
      end
      it "returns 50 for percentage(5,10)" do
        get_base_statistics.percentage(5,10).should == 50
      end
      it "returns 33 for percentage(1,3)" do
        get_base_statistics.percentage(1,3).should == 33
      end
    end
  end

  describe "get_review_statistics" do
    it "returns something for an empty application" do
      get_review_statistics.should_not be_nil
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
      it "returns 50 if 2 sessions exist and only 1 is reviewed " do
        review
        session
        get_review_statistics.percentage_of_sessions_reviewed.should == 50
      end
    end
    describe "percentage_of_presenters_who_review" do
      it "returns 50 if 1 session exists and it is reviewed " do
        review
        get_review_statistics.total_number_of_presenters.should == 2 #1 presenter, 1 reviewer
        get_review_statistics.percentage_of_presenters_who_review.should == 50
      end
    end
  end
  describe "number_of_reviews_by_presenters" do
    it "returns nothing for empty application" do
      get_review_statistics.number_of_reviews_by_presenters.should == []
    end
    context "when no reviews exist " do
      it "returns results for 0-reviews " do
        presenter
        get_review_statistics.number_of_reviews_by_presenters.should == [ [0, [presenter]] ]
      end
    end
    context "when 1 review exist " do
      it "returns session-presenter as 0-reviews and reviewer as 1-reviews " do
        review
        get_review_statistics.number_of_reviews_by_presenters.should == [ [0, [review.session.first_presenter]], [1, [review.presenter]] ]
      end
    end
    context "when 2 review exist by same reviewer" do
      it "returns that reviewer as 2-reviews " do
        review1 = FactoryGirl.create :review
        review2 = FactoryGirl.create :review, :presenter => review1.presenter
        get_review_statistics.number_of_reviews_by_presenters.should == [ [0, [review1.session.first_presenter, review2.session.first_presenter]], [2, [review1.presenter]] ]
      end
    end
  end
  describe "get_session_completeness_statistics" do
    it "returns something for an empty application" do
      get_session_completeness_statistics.should_not be_nil
    end
    describe "with_short_description" do
      it "returns 0 if no sessions are defined " do
        get_session_completeness_statistics.with_short_description.should == 0
        get_session_completeness_statistics.with_short_description_percentage.should == 100
      end
      it "returns 0 if a default session is defined " do
        session
        get_session_completeness_statistics.with_short_description.should == 0
        get_session_completeness_statistics.with_short_description_percentage.should == 0
      end
      it "returns 1 if a session is defined with a short description" do
        FactoryGirl.create(:session_with_presenter, :short_description => "blabla short" )
        get_session_completeness_statistics.with_short_description.should == 1
        get_session_completeness_statistics.with_short_description_percentage.should == 100
      end
    end
    describe "with_outline_or_timetable" do
      it "returns 0 if no sessions are defined " do
        get_session_completeness_statistics.with_outline_or_timetable.should == 0
        get_session_completeness_statistics.with_outline_or_timetable_percentage.should == 100
      end
      it "returns 0 if a default session is defined " do
        session
        get_session_completeness_statistics.with_outline_or_timetable.should == 0
        get_session_completeness_statistics.with_outline_or_timetable_percentage.should == 0
      end
      it "returns 1 if a session is defined with a outline" do
        FactoryGirl.create(:session_with_presenter, :outline_or_timetable => "blabla " )
        get_session_completeness_statistics.with_outline_or_timetable.should == 1
        get_session_completeness_statistics.with_outline_or_timetable_percentage.should == 100
      end
    end
    describe "updated_after_review" do
      it "returns 0 if no sessions are defined " do
        get_session_completeness_statistics.updated_after_review.should == 0
        get_session_completeness_statistics.updated_after_review_percentage.should == 100
      end
      it "returns 1 if a default session is defined " do
        session
        get_session_completeness_statistics.updated_after_review.should == 1
        get_session_completeness_statistics.updated_after_review_percentage.should == 100
      end
      it "returns 0 if a session is defined with review -and no updates afterwards" do
        FactoryGirl.create(:review, :created_at => 5.seconds.from_now , :updated_at => 5.seconds.from_now)
        get_session_completeness_statistics.updated_after_review.should == 0
        get_session_completeness_statistics.updated_after_review_percentage.should == 0
      end
    end
    describe "complete" do
      it "returns 0 if no sessions are defined " do
        get_session_completeness_statistics.complete.should == 0
        get_session_completeness_statistics.complete_percentage.should == 100
      end
      it "returns 0 if a default session is defined " do
        session
        get_session_completeness_statistics.complete.should == 0
        get_session_completeness_statistics.complete_percentage.should == 0
      end
      it "returns 1 if a session is defined with a short description" do
        FactoryGirl.create(:session_complete)
        get_session_completeness_statistics.complete.should == 1
        get_session_completeness_statistics.complete_percentage.should == 100
      end
    end
  end
  describe "PresenterCompleteness" do
    it "returns something for an empty application" do
      get_presenter_completeness_statistics.should_not be_nil
    end
    describe "with_name" do
      it "returns 0 if no presenters are defined " do
        get_presenter_completeness_statistics.with_name.should == 0
        get_presenter_completeness_statistics.with_name_percentage.should == 100
      end
      it "returns 0 if a default presenter is defined " do
        p = FactoryGirl.create(:presenter, :name => nil )
        get_presenter_completeness_statistics.with_name.should == 0
        get_presenter_completeness_statistics.with_name_percentage.should == 0
      end
      it "returns 1 if a presenter is defined with a name " do
        p = FactoryGirl.create(:presenter, :name => "MY NAME" )
        get_presenter_completeness_statistics.with_name.should == 1
        get_presenter_completeness_statistics.with_name_percentage.should == 100
      end
    end
    describe "with_bio" do
      it "returns 0 if no presenters are defined " do
        get_presenter_completeness_statistics.with_bio.should == 0
        get_presenter_completeness_statistics.with_bio_percentage.should == 100
      end
      it "returns 0 if a default presenter is defined " do
        FactoryGirl.create(:presenter, :bio => nil )
        get_presenter_completeness_statistics.with_bio.should == 0
        get_presenter_completeness_statistics.with_bio_percentage.should == 0
      end
      it "returns 1 if a presenter is defined with a short description" do
        FactoryGirl.create(:presenter, :bio => "MY BIO blablabla" )
        get_presenter_completeness_statistics.with_bio.should == 1
        get_presenter_completeness_statistics.with_bio_percentage.should == 100
      end
    end
  end
end
