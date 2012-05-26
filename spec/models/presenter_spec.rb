require 'spec_helper'

describe Presenter do
  it { should validate_presence_of :email } 
  describe 'sessions' do
    let(:presenter) { FactoryGirl.create :presenter }
    it "are empty by default" do
      presenter.sessions.should be_empty
    end
    it "can be added" do
      session = FactoryGirl.create(:session_with_presenter)
      presenter.sessions << session
      presenter.reload
      session.reload
      presenter.sessions.should include(session)
      session.presenters.should include(presenter)
    end
  end
  describe 'email' do 
    let(:presenter) { Presenter.new }

    context "when account is present" do 
      before { presenter.account = Account.new(email: "some@mail.nl") }

      it "is delegated to account" do
        presenter.email.should == "some@mail.nl"
      end
      it "assigment is delegated to account" do
        presenter.email = "other@mail.nl"
        presenter.account.email.should == "other@mail.nl"
      end
    end
    context "when account is not present" do
      it "is nil" do
        presenter.email.should == nil
      end
      it "assignment is delegated to new account" do
        presenter.email = "some@mail.nl" 
        presenter.account.email.should == "some@mail.nl" 
        presenter.email.should == "some@mail.nl" 
      end
    end
  end
end
