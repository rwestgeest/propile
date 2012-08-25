require 'spec_helper'

describe Vote do
  describe "saving" do
    it "is possible" do
      vote = FactoryGirl.create :vote
      Vote.first.should == vote
      Vote.first.presenter.votes.size.should == 1
      Vote.first.session.votes.size.should == 1
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

  def vote_by_presenter (apresenter) 
    vote = Vote.new
    vote.session = FactoryGirl.create :session_with_presenter 
    vote.presenter = apresenter
    vote.save
    vote.presenter.votes.size.should == 1
    apresenter.votes.size.should == 1
    vote
  end

  context "1 presenter votes" , :broken => true do 
  #context "1 presenter votes" do 
    let(:apresenter) { FactoryGirl.create(:presenter) }
    it "should validate max 10 sessions" do
      10.times do |i|
        vote = Vote.new 
        vote.session = FactoryGirl.create :session_with_presenter 
        vote.presenter = apresenter
        Vote.all.size.should == i
        vote.save!
        Vote.all.size.should == i+1
        vote.presenter.should_not be_nil
        p vote.presenter
        p vote.presenter.votes
        #vote.presenter.votes.size.should == i
        #apresenter.votes.size.should == i
        #vote_by_presenter ppresenter
      end
      Vote.all.size.should == 10
      apresenter.votes.size.should == 10
      vote = vote_by_presenter apresenter
      Vote.all.size.should == 11
      apresenter.votes.size.should == 11
      #vote.errors[:presenter].should_not be_empty 
    end
  end

  describe 'max_10_votes', :broken => true do 
    let(:apresenter) { FactoryGirl.create(:presenter) }
    it "should validate max 10 sessions" do
      10.times do |i|
        vote = Vote.new 
        vote.session = FactoryGirl.create :session_with_presenter 
        vote.presenter = apresenter
        Vote.all.size.should == i
        vote.save!
        Vote.all.size.should == i+1
        vote.presenter.should_not be_nil
        p vote.presenter
        p vote.presenter.votes
        #vote.presenter.votes.size.should == i
        #apresenter.votes.size.should == i
        #vote_by_presenter ppresenter
      end
      Vote.all.size.should == 10
      apresenter.votes.size.should == 10
      vote = vote_by_presenter apresenter
      Vote.all.size.should == 11
      apresenter.votes.size.should == 11
      #vote.errors[:presenter].should_not be_empty 
    end
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

  describe 'vote_of_presenter_for' do
    let(:presenter) { FactoryGirl.create(:presenter) }
    let(:session) { FactoryGirl.create :session_with_presenter }

    it "returns nil default " do
      Vote.vote_of_presenter_for(presenter.id, session.id).should == nil
    end
    it "returns true if presenter has vote for this session " do
      vote = FactoryGirl.create :vote
      Vote.vote_of_presenter_for(vote.presenter.id, vote.session.id).should == vote
    end
  end

end
