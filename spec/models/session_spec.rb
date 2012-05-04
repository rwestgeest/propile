require 'spec_helper'

describe Session do
  describe "saving" do 
    it "is possible" do
      session = FactoryGirl.create :session_with_presenter
      Session.first.should == session
    end
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
          session.presenters.first.email.should == "presenter_1@example.com"
          session.first_presenter_email.should == "presenter_1@example.com"
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
end
