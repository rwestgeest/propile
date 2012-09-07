require 'spec_helper'

describe Program do

  describe "saving" do
    it "is possible" do
      program = FactoryGirl.create :program
      Program.first.should == program
    end
  end

  describe "calculatePaf" do
    let(:vote) { FactoryGirl.create :vote  }
    let!(:presenter_with_matching_vote) { vote.presenter }
    let(:session) { vote.session }
    let(:program_entry) { FactoryGirl.create :program_entry, :session => session }
    let(:program) { program_entry.program }

    it "uses all presenters with votes" do
      presenter_with_matching_vote.reload
      Presenter.voting_presenters.should == [ presenter_with_matching_vote ]
      program.calculatePaf.should == 1
    end
    it "does not increase the paf if another persenter voted on a session outside the program" do
      presenter_with_matching_vote.reload
      other_vote = FactoryGirl.create :vote
      other_presenter = other_vote.presenter
      program.calculatePaf.should == 0
    end
  end

  describe  "calculateAvgPafForPresenters" do
    let(:program) { FactoryGirl.build :program  }
    let(:presenter) { FactoryGirl.build :presenter  }
    context "for empty presenter list" do
      it "returns emtpy 0" do
        program.calculateAvgPafForPresenters([]).should == 0
      end
    end
  end

  describe "calculatePafForPresenters" do
    let(:program) { FactoryGirl.build :program  }
    let(:presenter) { FactoryGirl.build :presenter  }
    context "for empty presenter list" do
      it "returns emtpy paf list" do
        list = program.calculatePafForPresenters([])
        #program.pafPerPresenter.should be_empty
        list.should be_empty
      end
    end
    context "when 1 presenter defined" do
      it "returns something for that presenter" do
        list = program.calculatePafForPresenters([presenter])
        list.size.should == 1
      end
    end
  end


  describe "calculatePafForOnePresenter" do
    let(:program) { FactoryGirl.build :program  }
    let(:vote1) { FactoryGirl.build :vote  }
    let(:vote2) { FactoryGirl.build :vote  }
    context "when presenter has not voted" do
      it "paf should be 0 " do
        program.calculatePafForOnePresenter([]).should == 0
      end
    end
    context "when presenter has voted for 1 session which is not scheduled in program" do
      it "paf should be 0 " do
        program.calculatePafForOnePresenter([vote1]).should == 0
      end
    end
    context "when presenter has voted for 1 session which is scheduled in program" do
      it "paf should be 1 " do
        program_entry = FactoryGirl.build(:program_entry, :program => program)
        program_entry.session = vote1.session
        program_entry.save
        program.calculatePafForOnePresenter([vote1]).should == 1
      end
    end
    context "when presenter has voted for 2 sessions which are scheduled in program" do
      it "paf should be 2 " do
        program_entry1 = FactoryGirl.build(:program_entry, :program => program)
        program_entry1.session = vote1.session
        program_entry1.save
        program_entry2 = FactoryGirl.build(:program_entry, :program => program)
        program_entry2.session = vote2.session
        program_entry2.save
        program.calculatePafForOnePresenter([vote1, vote2]).should == 2
      end
    end
    context "when presenter has voted for 2 sessions of which 1 is scheduled in program" do
      it "paf should be 1 " do
        program_entry1 = FactoryGirl.build(:program_entry, :program => program)
        program_entry1.session = vote1.session
        program_entry1.save
        program.calculatePafForOnePresenter([vote1, vote2]).should == 1
      end
    end
    context "when presenter has voted for 2 sessions which are scheduled in program in same slot" do
      it "paf should be 1 " do
        program_entry1 = FactoryGirl.build(:program_entry, :program => program)
        program_entry1.session = vote1.session
        program_entry1.save
        program_entry2 = FactoryGirl.build(:program_entry, :program => program)
        program_entry2.session = vote2.session
        program_entry2.slot = program_entry1.slot 
        program_entry2.save
        program.calculatePafForOnePresenter([vote1, vote2]).should == 1
      end
    end
  end

end
