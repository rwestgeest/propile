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
      mail.body.encoded.should match(presenter_login_guid)
    end
  end

end
