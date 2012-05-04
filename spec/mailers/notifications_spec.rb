require "spec_helper"

describe Notifications do
  describe "session_submit" do
    let(:presenter_email) { "presenter@company.nl"}
    let(:session) { FactoryGirl.build(:session) } 
    let(:mail) { Notifications.session_submit(presenter_email,session) }

    it "renders the headers" do
      mail.subject.should eq(I18n.t('notifications.session_submit.subject'))
      mail.to.should eq([presenter_email])
      mail.from.should eq([Notifications::FromAddress])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
      mail.body.encoded.should match session.title
    end
  end

end
