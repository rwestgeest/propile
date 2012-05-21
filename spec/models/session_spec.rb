require 'spec_helper'

describe Session do
  describe "saving" do 
    it "is possible" do
      session = FactoryGirl.create :session_with_presenter
      Session.first.should == session
    end
  end

  def isGuid(s)
    (s =~ /^(\{){0,1}[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}(\}){0,1}$/) != nil
  end

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:presenters) }

  describe "first presenter_email" do
    let!(:session) { Session.new } 
    it "is empty initially" do
      session.first_presenter_email.should be_empty
    end
    context "after setting" do
      context "on session without presenters" do
        let!(:session) { FactoryGirl.build(:session, :first_presenter_email => "presenter_1@example.com", :second_presenter_email => '')}
        it "builds a presenter" do
          session.first_presenter_email.should == "presenter_1@example.com"
          session.presenters.first.email.should == "presenter_1@example.com"
          (isGuid session.presenters.first.login_guid).should eq(true) 
        end 
        it "creates a presenter on save" do
          expect { session.save }.to change { Presenter.count }.by(1)
        end
      end
    end
  end
  describe "second presenter_email" do
    let!(:session) { FactoryGirl.build(:session, :first_presenter_email => "presenter_1@example.com")}
    it "is empty initially" do
      session.second_presenter_email.should be_empty
    end
    context "after setting" do
      context "on session without presenters" do
        let!(:session) { FactoryGirl.build(:session, :first_presenter_email => "presenter_1@example.com", :second_presenter_email => "presenter_2@example.com")}
        it "builds a presenters" do
          session.presenters.last.email.should == "presenter_2@example.com"
          session.second_presenter_email.should ==  "presenter_2@example.com"
        end 
        it "creates a presenter on save" do
          expect { session.save }.to change { Presenter.count }.by(2)
        end
      end
    end
  end

  describe "presenter names" do
    let!(:session) { Session.new } 
    it "empty session returns emtpy names" do
      session.presenter_names.should be_empty
    end
    context "first presenter email set" do
      let!(:session) { FactoryGirl.build(:session, :first_presenter_email => "presenter_1@example.com", :second_presenter_email => '')}
      it "returns first presenter email" do
        session.presenters.first.email.should == "presenter_1@example.com"
        session.presenter_names.should == "presenter_1@example.com"
      end
    end
    context "first and second presenter email set" do
      let!(:session) { FactoryGirl.build(:session, :first_presenter_email => "presenter_1@example.com", :second_presenter_email => 'presenter_2@example.com')}
      it "returns first presenter email" do
        session.presenter_names.should == "presenter_1@example.com & presenter_2@example.com"
      end
    end
    # how can I add names to my presenters?
    context "first presenter email and name set, no second presenter" do
      let!(:session) { FactoryGirl.build(:session, :first_presenter_email => "presenter_1@example.com", :second_presenter_email => '')}
      it "returns first presenter name" do
        session.presenters.first.name = "Petra The Firstpresenter"
        session.presenter_names.should == "Petra The Firstpresenter"
      end
    end
    context "first presenter email and name set, second presenter only email" do
      let!(:session) { FactoryGirl.build(:session, :first_presenter_email => "presenter_1@example.com", :second_presenter_email => 'presenter_2@example.com')}
      it "returns first presenter name" do
        session.presenters.first.name = "Petra The Firstpresenter"
        session.presenter_names.should == "Petra The Firstpresenter & presenter_2@example.com"
      end
    end
    context "both presenters name set" do
      let!(:session) { FactoryGirl.build(:session, :first_presenter_email => "presenter_1@example.com", :second_presenter_email => 'presenter_2@example.com')}
      it "returns first presenter name" do
        session.presenters.first.name = "Petra The Firstpresenter"
        session.presenters.second.name = "Peter The Secondpresenter"
        session.presenter_names.should == "Petra The Firstpresenter & Peter The Secondpresenter"
      end
    end
  end
end
