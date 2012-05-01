require 'spec_helper'

describe Session do
  describe "saving" do 
    it "is possible" do
      session = FactoryGirl.create :session
      Session.first.should == session
    end
  end
  describe "first presenter_email" do
    context "on session without presenters" do
      let!(:session) { FactoryGirl.build(:session, :first_presenter_email => "presenter_1@example.com", :second_presenter_email => nil)}
      it "builds a presenter" do
        session.presenters.first.email.should == "presenter_1@example.com"
      end 
      it "creates a presenter on save" do
        expect { session.save }.to change { Presenter.count }.by(1)
      end
    end
  end
  describe "second presenter_email" do
    context "on session without presenters" do
      let!(:session) { FactoryGirl.build(:session, :first_presenter_email => "presenter_1@example.com", :second_presenter_email => "presenter_2@example.com")}
      it "builds a presenters" do
        session.presenters.last.email.should == "presenter_2@example.com"
      end 
      it "creates a presenter on save" do
        expect { session.save }.to change { Presenter.count }.by(2)
      end
    end
  end
end
