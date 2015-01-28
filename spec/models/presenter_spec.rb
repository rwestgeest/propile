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

  describe "name_filled_in?" do
    it "is true if set" do
      Presenter.new(:name => "rob").should be_name_filled_in
    end
    it "is false if not set" do
      Presenter.new(:email => "rob@rob.nl").should_not be_name_filled_in
    end
    it "is email if empty" do
      Presenter.new(:email => "rob@rob.nl", :name => "").should_not be_name_filled_in
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

  describe "website" do
    let(:presenter) { Presenter.new }

    it "allows empty website" do
      presenter.website = " "
      presenter.website.should ==  ""
    end

    it "allows http URLs" do
      presenter.website = "http://www.xpday.net"
      presenter.website.should ==  "http://www.xpday.net"
    end

    it "allows https URLs" do
      presenter.website = "https://www.xpday.net"
      presenter.website.should ==  "https://www.xpday.net"
    end

    it "uses http:// if no protocol specified" do
      presenter.website = "www.xpday.net"
      presenter.website.should ==  "http://www.xpday.net"
    end

    it "uses http:// if no protocol specified even when there are spaces" do
      presenter.website = " www.xpday.net"
      presenter.website.should ==  "http://www.xpday.net"
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
    it "is excluded if the session was removed (because of a bug in session.destroy)" do
      review.session.destroy
      review.presenter.sessions_reviewed.should == []
    end
  end

  describe "sessions_involved" do

    it "returns nothing if nothing submitted or reviewed or commented" do
      presenter.sessions_involved.should be_empty
    end

    context "the session I have submitted" do
      let (:session) {FactoryGirl.create :session_with_presenter}
      it "is included" do
        session.first_presenter.sessions_involved.should == [session]
      end

    end

    context "the sessions that i reviewed" do 
      let (:review) {FactoryGirl.create :review}
      it "is included" do
        review.presenter.sessions_involved.should == [review.session]
      end

      it "is included once if i reviewed it twice " do
        FactoryGirl.create :review, :presenter => review.presenter, :session => review.session
        review.presenter.sessions_involved.should == [review.session]
      end

      it "is excluded if the session was removed (because of bug in session.destroy)" do
        review.session.destroy
        review.presenter.sessions_involved.should == []
      end
    end

    context "the sessions that i commented" do 
      let (:comment) {FactoryGirl.create :comment}
      it "is included" do
        comment.presenter.sessions_involved.should == [comment.review.session]
      end

      it "is included once if i commented it twice " do
        FactoryGirl.create :comment, :presenter => comment.review.presenter, :review => comment.review
        comment.review.presenter.sessions_involved.should == [comment.review.session]
      end

      it "is excluded if the session was removed" do
        comment.review.session.destroy
        comment.review.presenter.sessions_involved.should == []
      end
    end

  end

  describe "archive_all" do
    def compare_archived (archived_presenter, presenter)
      archived_presenter.name.should == presenter.name
      archived_presenter.email.should == presenter.email
      archived_presenter.bio.should == presenter.bio
      archived_presenter.twitter_id.should == presenter.twitter_id
      archived_presenter.profile_image.should == presenter.profile_image
      archived_presenter.website.should == presenter.website
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
