require 'spec_helper'

describe Postman do
  describe "notify_review_creation" do
    let(:review)  { FactoryGirl.create :review }
    let(:session) { review.session }
    it "sends a review_creation notification to reviewer and presenters" do
      Postman.should_receive(:deliver).with(:review_creation, review.presenter.email, review)
      Postman.should_receive(:deliver).with(:review_creation, session.first_presenter_email, review)
      Postman.notify_review_creation(review)
    end
    it "sends a mail to second presenter if it exists" do
      session.second_presenter_email = "second_presenter@email" 
      Postman.stub(:deliver).with(:review_creation, review.presenter.email, review)
      Postman.stub(:deliver).with(:review_creation, session.first_presenter_email, review)
      Postman.should_receive(:deliver).with(:review_creation, session.second_presenter_email, review)
      Postman.notify_review_creation(review)
    end
    it "does not send a notification twice to the same email address" do
      session.first_presenter = review.presenter
      Postman.should_receive(:deliver).with(:review_creation, review.presenter.email, review)
      Postman.notify_review_creation(review)
    end
  end
  describe "notify comment creation" do
    let(:comment) { FactoryGirl.create :comment } 
    let(:review) { comment.review } 
    let(:session) { review.session } 
    before do 
      comment.presenter.email = "commenter@example.com"
      review.presenter.email = "reviewer@example.com"
      session.first_presenter_email = "presenter@example.com"
    end
    it "sends a comment_creation notification to commentter reviewer and presenter" do
      Postman.should_receive(:deliver).with(:comment_creation, comment.presenter.email, comment)
      Postman.should_receive(:deliver).with(:comment_creation, review.presenter.email, comment)
      Postman.should_receive(:deliver).with(:comment_creation, session.first_presenter_email, comment)
      Postman.notify_comment_creation(comment)
    end
    it "sends a comment_creation notification to commentter reviewer and presenter" do
      session.second_presenter_email = "second_presenter@email" 
      Postman.stub(:deliver)
      Postman.should_receive(:deliver).with(:comment_creation, session.second_presenter_email, comment)
      Postman.notify_comment_creation(comment)
    end
    it "does not send a notification twice to the same email address" do
      session.first_presenter = review.presenter = comment.presenter
      Postman.should_receive(:deliver).with(:review_creation, review.presenter.email, review).once
      Postman.notify_review_creation(review)
    end
  end
end
