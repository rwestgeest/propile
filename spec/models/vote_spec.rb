require 'spec_helper'

describe Vote do
  describe "saving" do
    it "is possible" do
      vote = FactoryGirl.create :vote
      Vote.first.should == vote
    end
  end

  it { should validate_presence_of(:presenter) }
  it { should validate_presence_of(:session) }

  it "should validate session is not your own" do
    vote = Vote.new
    vote.session = FactoryGirl.create :session_with_presenter 
    vote.presenter = vote.session.first_presenter
    vote.save
    vote.errors[:presenter].should_not be_empty 
  end

  describe 'presenter_has_voted_for?' do
    let(:presenter) { FactoryGirl.create(:presenter) }
    let(:session) { FactoryGirl.create :session_with_presenter }

    it "has no vote by default " do
      Vote.presenter_has_voted_for?(presenter.id, session.id).should == false
    end
    it "returns true if presenter has vote for this session " do
      vote = FactoryGirl.create :vote
      Vote.presenter_has_voted_for?(vote.presenter.id, vote.session.id).should == true
    end
  end

end
