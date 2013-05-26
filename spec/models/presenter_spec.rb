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

  describe "archive_all" do
    def compare_archived (archived_presenter, presenter)
      archived_presenter.name.should == presenter.name
      archived_presenter.email.should == presenter.email
      archived_presenter.bio.should == presenter.bio
    end

    it "copies presenter to archived_presenter" do
      presenter = FactoryGirl.create :presenter 
      Presenter.archive_all
      ArchivedPresenter.all.size.should == 1
      compare_archived(ArchivedPresenter.all.first, presenter)
    end
    it "removes presenter from presenter" do
      presenter = FactoryGirl.create :presenter 
      Presenter.archive_all
      Presenter.all.should be_empty
    end
    it "copies maintainer to archived_presenter" do
      maintainer = FactoryGirl.create :presenter 
      maintainer.account = FactoryGirl.create :confirmed_account
      maintainer.save
      Presenter.archive_all
      ArchivedPresenter.all.size.should == 1
      compare_archived(ArchivedPresenter.all.first, maintainer)
    end
    it "does not remove maintainer from presenter" do
      maintainer = FactoryGirl.create :presenter 
      maintainer.account = FactoryGirl.create :confirmed_account
      maintainer.save
      Presenter.archive_all
      Presenter.all.size.should == 1
    end
    it "moves presenter to archived_presenter" do
      presenter = FactoryGirl.create :presenter 
      Presenter.archive_all
      Presenter.all.should be_empty
      ArchivedPresenter.all.size.should == 1
      compare_archived(ArchivedPresenter.all.first, presenter)
    end
  end
end
