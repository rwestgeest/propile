require "spec_helper"

describe Notifications do

  describe "session_submit" do
    let(:presenter) { FactoryGirl.create :presenter }
    let(:presenter_login_guid) { presenter.account.authentication_token }
    let(:session) { FactoryGirl.build(:session) } 
    let(:mail) { Notifications.session_submit(presenter,session) }

    it "renders the headers" do
      mail.subject.should eq(Propile::Application.mail_subject_prefix + I18n.t('notifications.session_submit.subject'))
      mail.to.should eq([presenter.email])
      mail.from.should eq([Notifications::FromAddress])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
      mail.body.encoded.should match session.title
      mail.body.encoded.should match(account_response_session_url(presenter_login_guid))
    end
  end

  describe "account_reset" do
    let(:account) { FactoryGirl.create :account } 
    let(:mail) { Notifications.account_reset account }

    it "renders the headers" do
      mail.subject.should eq("Account reset")
      mail.to.should eq([account.email])
      mail.from.should eq([Notifications::FromAddress])
    end

    it "puts the response url in the body" do
      mail.body.encoded.should include(account_response_session_url(account.authentication_token))
    end
  end

  describe "review_creation" do
    let(:review) { FactoryGirl.create :review } 
    let(:session) { review.session }
    let(:mail) { Notifications.review_creation "to@mail.com", review }
    it "renders the headers" do
      mail.subject.should  == Propile::Application.mail_subject_prefix + "Review on session '#{session.title}'"
      mail.to.should  == ['to@mail.com']
      mail.from.should == [ Notifications::FromAddress ]
    end

    it "renders the body" do
      mail.body.encoded.should match session.title
      mail.body.encoded.should match review.presenter.name 
      mail.body.encoded.should match review.score.to_s
      mail.body.encoded.should match review.things_i_like
      mail.body.encoded.should match review.things_to_improve
      mail.body.encoded.should match(review_url(review))
    end
  end

  describe "comment_creation" do
    let(:comment) { FactoryGirl.create :comment } 
    let(:review) { comment.review } 
    let(:session) { review.session }
    let(:mail) { Notifications.comment_creation "to@mail.com", comment }
    it "renders the headers" do
      mail.subject.should  == Propile::Application.mail_subject_prefix + "Comment for review on session '#{session.title}'"
      mail.to.should  == ['to@mail.com']
      mail.from.should == [ Notifications::FromAddress ]
    end

    it "renders the body" do
      mail.body.encoded.should match session.title
      mail.body.encoded.should match comment.presenter.name 
      mail.body.encoded.should match review.presenter.name 
      mail.body.encoded.should match(comment_url(comment))
    end
  end
end
