require 'spec_helper'

describe Presenter do
  it { should validate_presence_of :email } 
  ["rob@", "@mo.nl", "123.nl", "123@nl", "aaa.123.nl", "aaa.123@nl"].each do |illegal_mail|
    it { should_not allow_value(illegal_mail).for(:email) }
  end

  describe "name" do
    it "is name if set" do
      Presenter.new(:name => "rob").name.should == "rob"
    end
    it "is email if not set" do
      Presenter.new(:email => "rob@rob.nl").name.should == "rob@rob.nl"
    end
    it "is email if empty" do
      Presenter.new(:email => "rob@rob.nl", :name => "").name.should == "rob@rob.nl"
    end
  end

  describe 'sessions' do
    let(:presenter) { FactoryGirl.create :presenter }
    it "are empty by default" do
      presenter.sessions.should be_empty
    end
    it "can be added as first presenter session" do
      session = FactoryGirl.create(:session_with_presenter)
      session.first_presenter = presenter
      session.save
      session.reload
      presenter.reload
      presenter.sessions.should include(session)
      session.presenters.should include(presenter)
    end
  end

  describe 'account' do
    it "is a presenter account" do
      Presenter.new.account.role.should == Account::Presenter
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

  describe 'has_vote_for?' do
    let(:presenter) { Presenter.new }
    session = FactoryGirl.create(:session_with_presenter)
    it "has no vote by default " do
      presenter.has_vote_for?(session.id).should == false
    end
    it "returns true if presenter has vote for this session " do
      vote = FactoryGirl.create :vote
      vote.presenter.has_vote_for?(vote.session.id).should == true
    end
  end
end
