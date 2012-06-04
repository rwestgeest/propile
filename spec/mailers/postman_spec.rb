require 'spec_helper'

describe Postman do
  describe "notify_review_creation" do
    let(:review)  { FactoryGirl.build :review }
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
  end
end
