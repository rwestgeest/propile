require 'spec_helper'

describe Presenter do
  let(:presenter) { FactoryGirl.create :presenter }
  def create_presenter
    presenter
  end
  let (:maintainer) { FactoryGirl.create :presenter, :account =>  (FactoryGirl.create :confirmed_account)}
  def create_maintainer
    maintainer
  end

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

  describe "sessions_reviewed" do
    let (:review) {FactoryGirl.create :review}
    it "returns nothing if nothing reviewed" do
      presenter.sessions_reviewed.should be_empty
    end
    it "returns reviewed sessions " do
      review.presenter.sessions_reviewed.should == [review.session]
    end
  end

  describe "sessions_involved" do
    let (:session) {FactoryGirl.create :session_with_presenter}
    let (:review) {FactoryGirl.create :review}
    let (:comment) {FactoryGirl.create :comment}
    it "returns nothing if nothing submitted or reviewed or commented" do
      presenter.sessions_involved.should be_empty
    end
    it "returns submitted sessions if something submitted" do
      session.first_presenter.sessions_involved.should == [session]
    end
    it "returns reviewed sessions if something reviewed" do
      review.presenter.sessions_involved.should == [review.session]
    end
    it "returns commented sessions if something commented" do
      comment.presenter.sessions_involved.should == [comment.review.session]
    end
    it "returns each session only once " do
      presenter = session.first_presenter
      FactoryGirl.create :review, :presenter => presenter, :session => session
      presenter.sessions_involved.should == [session]
    end
  end

  describe "archive_all" do
    def compare_archived (archived_presenter, presenter)
      archived_presenter.name.should == presenter.name
      archived_presenter.email.should == presenter.email
      archived_presenter.bio.should == presenter.bio
    end

    it "copies presenter to archived_presenter" do
      create_presenter
      Presenter.archive_all
      ArchivedPresenter.all.size.should == 1
      compare_archived(ArchivedPresenter.all.first, presenter)
    end
    it "removes presenter from presenter" do
      create_presenter
      Presenter.archive_all
      Presenter.all.should be_empty
    end
    it "copies maintainer to archived_presenter" do
      create_maintainer
      Presenter.archive_all
      ArchivedPresenter.all.size.should == 1
      compare_archived(ArchivedPresenter.all.first, maintainer)
    end
    it "does not remove maintainer from presenter" do
      create_maintainer
      Presenter.archive_all
      Presenter.all.size.should == 1
    end
    it "moves maintainer to archived_presenter" do
      create_presenter
      Presenter.archive_all
      Presenter.all.should be_empty
      ArchivedPresenter.all.size.should == 1
      compare_archived(ArchivedPresenter.all.first, presenter)
    end
    it "updates presenter in archived_presenter if it already exists " do
      archived = FactoryGirl.create :archived_presenter
      account = FactoryGirl.create :confirmed_account, :email => archived.email
      presenter = FactoryGirl.create :presenter, :bio => "bla bla bla", :account => account
      Presenter.archive_all
      ArchivedPresenter.all.size.should == 1
      compare_archived(ArchivedPresenter.all.first, presenter)
    end
  end
end
