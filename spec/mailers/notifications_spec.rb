require "spec_helper"

describe Notifications do

  describe "session_submit" do
    let(:presenter) { FactoryGirl.create :presenter }
    let(:presenter_login_guid) { presenter.account.authentication_token }
    let(:session) { FactoryGirl.build(:session) } 
    let(:mail) { Notifications.session_submit(presenter,session) }

    it "renders the headers" do
      mail.subject.should eq(I18n.t('notifications.session_submit.subject'))
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

end
