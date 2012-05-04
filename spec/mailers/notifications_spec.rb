require "spec_helper"

describe Notifications do
  describe "session_submit" do
    let(:mail) { Notifications.session_submit }

    it "renders the headers" do
      mail.subject.should eq("Session submit")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
