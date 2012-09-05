require 'spec_helper'

describe Program do

  describe "saving" do
    it "is possible" do
      program = FactoryGirl.create :program
      Program.first.should == program
    end
  end

  describe "calculatePafForAllPresenters" do
    let(:program) { FactoryGirl.build :program  }
    let(:presenter) { FactoryGirl.build :presenter  }
    context "for empty presenter list" do
      it "returns emtpy paf list" do
        list = program.calculatePafForAllPresenters([])
        #program.pafPerPresenter.should be_empty
        list.should be_empty
      end
    end
    context "when 1 presenter defined" do
      it "returns something for that presenter" do
        list = program.calculatePafForAllPresenters([presenter])
        #program.pafPerPresenter.size.should == 1
        list.size.should == 1
      end
    end
  end


  describe "calculatePafForPresenter" do
    let(:program) { FactoryGirl.build :program  }
    let(:vote) { FactoryGirl.build :vote  }
    context "when presenter has not voted" do
      it "paf should be 0 " do
        program.calculatePafForPresenter([]).should == 0
      end
    end
    context "when presenter has voted for 1 session which is not scheduled in program" do
      it "paf should be 0 " do
        program.calculatePafForPresenter([vote]).should == 0
      end
    end
    context "when presenter has voted for 1 session which is scheduled in program" do
      it "paf should be 1 " do
        program_entry = FactoryGirl.build(:program_entry, :program => program)
        program_entry.session = vote.session
        program_entry.save
        program.calculatePafForPresenter([vote]).should == 1
      end
    end
  end

end
