require 'spec_helper'

describe Program do

  let(:program) { FactoryGirl.build :program  }
  def a_program_entry_in_slot(program, slot)
    FactoryGirl.create(:program_entry, :program => program, :slot => slot)
  end
  def a_program_entry_in_track(program, track)
    FactoryGirl.create(:program_entry, :program => program, :track => track)
  end
  def a_program_entry_in_slot_and_track(program, slot, track)
    FactoryGirl.create(:program_entry, :program => program, :slot => slot, :track => track)
  end

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
      Presenter.voting_presenters.should == [ presenter_with_matching_vote ]
      program.calculatePaf.should == 1
    end
    it "does not increase the paf if another persenter voted on a session outside the program" do
      other_vote = FactoryGirl.create :vote
      other_presenter = other_vote.presenter
      program.calculatePaf.should == 0
    end
  end

  describe  "calculateAvgPafForPresenters" do
    let(:presenter) { FactoryGirl.build :presenter  }
    context "for empty presenter list" do
      it "returns emtpy 0" do
        program.calculateAvgPafForPresenters([]).should == 0
      end
    end
  end

  describe "calculatePafForPresenters" do
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
        program_entry = a_program_entry_for(program, vote1.session)
        program.calculatePafForOnePresenter([vote1]).should == 1
      end
    end
    context "when presenter has voted for 2 sessions which are scheduled in program" do
      it "paf should be 2 " do
        program_entry1 = a_program_entry_for(program, vote1.session)
        program_entry2 = a_program_entry_for(program, vote2.session)
        program.calculatePafForOnePresenter([vote1, vote2]).should == 2
      end
    end
    context "when presenter has voted for 2 sessions of which 1 is scheduled in program" do
      it "paf should be 1 " do
        program_entry1 = a_program_entry_for(program, vote1.session)
        program.calculatePafForOnePresenter([vote1, vote2]).should == 1
      end
    end
    context "when presenter has voted for 2 sessions which are scheduled in program in same slot" do
      it "paf should be 1 " do
        program_entry1 = a_program_entry_for(program, vote1.session)
        a_program_entry_for(program, vote2.session).update_attribute :slot, program_entry1.slot 
        program.calculatePafForOnePresenter([vote1, vote2]).should == 1
      end
    end

    def a_program_entry_for(program, session)
      FactoryGirl.create(:program_entry, :program => program, :session => session)
    end
  end

  describe "maxSlot" do
    context "when no slots in program " do
      it "maxSlot should be 0 " do
        program.maxSlot.should == 0
      end
    end
    context "when a slot in program " do
      it "maxSlot should be number of slot " do
        a_program_entry_in_slot(program, 5)
        program.maxSlot.should == 5
      end
    end
    context "when 2 slots in program " do
      it "maxSlot should be max slot " do
        a_program_entry_in_slot(program, 5)
        a_program_entry_in_slot(program, 10)
        program.maxSlot.should == 10
      end
    end
    context "when 2 entries in program on same slot" do
      it "maxSlot should be max slot " do
        a_program_entry_in_slot(program, 5)
        a_program_entry_in_slot(program, 5)
        program.maxSlot.should == 5
      end
    end
  end

  describe "eachSlot" do
    context "when no slots in program " do
      it "eachSlot should do nothing " do
        program.eachSlot {|i| fail}
      end
    end
    context "when a slot in program " do
      it "eachSlot should do something for each slot -- empty or not" do
        arr = []
        a_program_entry_in_slot(program, 5)
        program.eachSlot {|i| arr << i }
        arr.size.should equal 5
      end
    end
  end

  describe "maxTrack" do
    context "when no tracks in program " do
      it "maxTrack should be 0 " do
        program.maxTrack.should == 0
      end
    end
    context "when a track in program " do
      it "maxTrack should be number of track " do
        a_program_entry_in_track(program, 5)
        program.maxTrack.should == 5
      end
    end
    context "when 2 tracks in program " do
      it "maxTrack should be max track " do
        a_program_entry_in_track(program, 5)
        a_program_entry_in_track(program, 10)
        program.maxTrack.should == 10
      end
    end
  end

  describe "eachTrack" do
    context "when no tracks in program " do
      it "eachTrack should do nothing " do
        program.eachTrack {|i| fail}
      end
    end
    context "when a track in program " do
      it "eachTrack should do something for each track -- empty or not" do
        arr = []
        a_program_entry_in_track(program, 5)
        program.eachTrack {|i| arr << i }
        arr.size.should equal 5
      end
    end
  end

  describe "entry" do
    context "when no entries in program " do
      it "entry should return nil" do
        program.entry(1,1).should be_nil
      end
      it "entry with incorrect coordinates should return nil" do
        a_program_entry_in_slot_and_track(program, 1, 1)
        program.entry(2,2).should be_nil
      end
      it "entry with correct coordinates should return the entry" do
        entry = a_program_entry_in_slot_and_track(program, 1, 1)
        program.entry(1,1).should == entry
      end
    end
  end

  describe "insertSlot" do
    context "when no entries in program " do
      it "insertSlot 1 should do nothing" do
        program.insertSlot(1).maxSlot.should == 0
      end
    end
    context "when 1 entry in program on slot 1" do
      it "insertSlot 1 should NOT insert an entry " do
        entry = a_program_entry_in_slot(program, 1)
        program.insertSlot(1).program_entries.size.should == 1
      end
      it "insertSlot 1 should move entry to next slot" do
        entry = a_program_entry_in_slot(program, 1)
        program.insertSlot(1).maxSlot.should == 2
        program.program_entries.size.should == 1
        program.save
        entry.reload.slot.should == 2
      end
      it "insertSlot 2 should do nothing" do
        entry = a_program_entry_in_slot(program, 1)
        program.insertSlot(2).maxSlot.should == 1
        program.save
        entry.reload.slot.should == 1
      end
    end
    context "when 2 entries in program on different slots" do
      it "insertSlot before entry 1 should move both entries to next slot" do
        entry_on_slot_2 = a_program_entry_in_slot(program, 2)
        entry_on_slot_5 = a_program_entry_in_slot(program, 5)
        program.insertSlot(1).maxSlot.should == 6
        program.save
        entry_on_slot_2.reload.slot.should == 3
        entry_on_slot_5.reload.slot.should == 6
      end
      it "insertSlot between the entries should move only entry 2 to next slot" do
        entry_on_slot_2 = a_program_entry_in_slot(program, 2)
        entry_on_slot_5 = a_program_entry_in_slot(program, 5)
        program.insertSlot(4).maxSlot.should == 6
        program.save
        entry_on_slot_2.reload.slot.should == 2
        entry_on_slot_5.reload.slot.should == 6
      end
      it "insertSlot after entry 2 should do nothing" do
        entry_on_slot_2 = a_program_entry_in_slot(program, 2)
        entry_on_slot_5 = a_program_entry_in_slot(program, 5)
        program.insertSlot(6).maxSlot.should == 5
        program.save
        entry_on_slot_2.reload.slot.should == 2
        entry_on_slot_5.reload.slot.should == 5
      end
    end
  end

  describe "insertTrack" do
    context "when no entries in program " do
      it "insertTrack 1 should do nothing" do
        program.insertTrack(1).maxTrack.should == 0
      end
    end
    context "when 1 entry in program on track 1" do
      it "insertTrack 1 should NOT insert an entry " do
        entry = a_program_entry_in_track(program, 1)
        program.insertTrack(1).program_entries.size.should == 1
      end
      it "insertTrack 1 should move entry to next track" do
        entry = a_program_entry_in_track(program, 1)
        program.insertTrack(1).maxTrack.should == 2
        program.program_entries.size.should == 1
        program.save
        entry.reload.track.should == 2
      end
      it "insertTrack 2 should do nothing" do
        entry = a_program_entry_in_track(program, 1)
        program.insertTrack(2).maxTrack.should == 1
        program.save
        entry.reload.track.should == 1
      end
    end
    context "when 2 entries in program on different tracks" do
      it "insertTrack before entry 1 should move both entries to next track" do
        entry_on_track_2 = a_program_entry_in_track(program, 2)
        entry_on_track_5 = a_program_entry_in_track(program, 5)
        program.insertTrack(1).maxTrack.should == 6
        program.save
        entry_on_track_2.reload.track.should == 3
        entry_on_track_5.reload.track.should == 6
      end
      it "insertTrack between the entries should move only entry 2 to next track" do
        entry_on_track_2 = a_program_entry_in_track(program, 2)
        entry_on_track_5 = a_program_entry_in_track(program, 5)
        program.insertTrack(4).maxTrack.should == 6
        program.save
        entry_on_track_2.reload.track.should == 2
        entry_on_track_5.reload.track.should == 6
      end
      it "insertTrack after entry 2 should do nothing" do
        entry_on_track_2 = a_program_entry_in_track(program, 2)
        entry_on_track_5 = a_program_entry_in_track(program, 5)
        program.insertTrack(6).maxTrack.should == 5
        program.save
        entry_on_track_2.reload.track.should == 2
        entry_on_track_5.reload.track.should == 5
      end
    end
  end

  describe "removeSlot" do
    context "when no entries in program " do
      it "removeSlot 1 should do nothing" do
        program.removeSlot(1).maxSlot.should == 0
      end
    end
    context "when 1 entry in program on slot 2" do
      it "removeSlot 3 should NOT remove an entry " do
        entry = a_program_entry_in_slot(program, 2)
        program.removeSlot(3).program_entries.size.should == 1
      end
      it "removeSlot 2 should destroy entry" do
        entry = a_program_entry_in_slot(program, 2)
        program.removeSlot(2).save
        program.maxSlot.should == 0
        program.program_entries.size.should == 0
        ProgramEntry.all.should be_empty
      end
      it "removeSlot 1 should move entry one row up" do
        entry = a_program_entry_in_slot(program, 2)
        program.removeSlot(1).save
        program.maxSlot.should == 1
        entry.reload.slot.should == 1
      end
    end
    context "when 2 entries in program on different slots" do
      it "removeSlot before entry 1 should move both entries one row up" do
        entry_on_slot_2 = a_program_entry_in_slot(program, 2)
        entry_on_slot_5 = a_program_entry_in_slot(program, 5)
        program.removeSlot(1).save
        program.maxSlot.should == 4
        entry_on_slot_2.reload.slot.should == 1
        entry_on_slot_5.reload.slot.should == 4
      end
      it "removeSlot between the entries should move only entry 2 up" do
        entry_on_slot_2 = a_program_entry_in_slot(program, 2)
        entry_on_slot_5 = a_program_entry_in_slot(program, 5)
        program.removeSlot(4).save
        program.maxSlot.should == 4
        entry_on_slot_2.reload.slot.should == 2
        entry_on_slot_5.reload.slot.should == 4
      end
      it "removeSlot after entry 2 should do nothing" do
        entry_on_slot_2 = a_program_entry_in_slot(program, 2)
        entry_on_slot_5 = a_program_entry_in_slot(program, 5)
        program.removeSlot(6).save
        program.maxSlot.should == 5
        entry_on_slot_2.reload.slot.should == 2
        entry_on_slot_5.reload.slot.should == 5
      end
    end
  end

  describe "removeTrack" do
    context "when no entries in program " do
      it "removeTrack 1 should do nothing" do
        program.removeTrack(1).maxTrack.should == 0
      end
    end
    context "when 1 entry in program on track 2" do
      it "removeTrack 3 should NOT remove an entry " do
        entry = a_program_entry_in_track(program, 2)
        program.removeTrack(3).program_entries.size.should == 1
      end
      it "removeTrack 2 should destroy entry" do
        entry = a_program_entry_in_track(program, 2)
        program.removeTrack(2).save
        program.maxTrack.should == 0
        program.program_entries.size.should == 0
        ProgramEntry.all.should be_empty
      end
      it "removeTrack 1 should move entry one row up" do
        entry = a_program_entry_in_track(program, 2)
        program.removeTrack(1).save
        program.maxTrack.should == 1
        entry.reload.track.should == 1
      end
    end
    context "when 2 entries in program on different tracks" do
      it "removeTrack before entry 1 should move both entries one row up" do
        entry_on_track_2 = a_program_entry_in_track(program, 2)
        entry_on_track_5 = a_program_entry_in_track(program, 5)
        program.removeTrack(1).save
        program.maxTrack.should == 4
        entry_on_track_2.reload.track.should == 1
        entry_on_track_5.reload.track.should == 4
      end
      it "removeTrack between the entries should move only entry 2 up" do
        entry_on_track_2 = a_program_entry_in_track(program, 2)
        entry_on_track_5 = a_program_entry_in_track(program, 5)
        program.removeTrack(4).save
        program.maxTrack.should == 4
        entry_on_track_2.reload.track.should == 2
        entry_on_track_5.reload.track.should == 4
      end
      it "removeTrack after entry 2 should do nothing" do
        entry_on_track_2 = a_program_entry_in_track(program, 2)
        entry_on_track_5 = a_program_entry_in_track(program, 5)
        program.removeTrack(6).save
        program.maxTrack.should == 5
        entry_on_track_2.reload.track.should == 2
        entry_on_track_5.reload.track.should == 5
      end
    end
  end

  def active_program_now
    active_program(DateTime.now)
  end
  def active_program (activation_date)
    FactoryGirl.create(:program, :activation => activation_date) 
  end
  describe "active?" do
    it "default no program is active" do
      program.active?.should ==  false
    end
    it "activated program is active" do
      active_program_now.active?.should == true
    end
    it "last activated program is active" do
      p1 = active_program ( DateTime.new(2012,1,1) )
      p2 = active_program ( DateTime.new(2012,2,2) )
      p1.active?.should == false
      p2.active?.should == true
    end
  end

  describe "sessionsInProgram" do
    def a_program_entry_for(program)
      FactoryGirl.create(:program_entry, :program => program)
    end
    def a_program_entry_without_session_for(program)
      FactoryGirl.create(:program_entry_wo_session, :program => program)
    end
    it "for empty program returns emtpy list " do
      active_program_now.sessionsInProgram.should be_empty
    end
    it "for program with session returns that session" do
      p = active_program_now
      program_entry = a_program_entry_for(p)
      p.sessionsInProgram.should == [program_entry.session]
    end
    it "for program with session returns no other sessions" do
      p = active_program_now
      program_entry = a_program_entry_for(p)
      another_session = FactoryGirl.create(:session_with_presenter)
      p.program_entries.size.should == 1
      p.sessionsInProgram.should == [program_entry.session]
    end
    it "for program with non-session entries does not return anything " do
      p = active_program_now
      program_entry = a_program_entry_for(p)
      a_program_entry_without_session_for(p)
      p.program_entries.size.should == 2
      p.sessionsInProgram.should == [program_entry.session]
    end
  end

  describe "presentersInProgram" do
    it "for empty program contains no presenters" do
      active_program_now.presentersInProgram.should be_empty
    end
    it "for program with session contains presenters for that session" do
      p = active_program_now
      program_entry = a_program_entry_for_session_with_2_presenters(p)
      p.presentersInProgram.to_a.should == [program_entry.session.first_presenter, program_entry.session.second_presenter]
    end
    it "for program with session contains every presenter only once" do
      p = active_program_now
      program_entry = a_program_entry_for(p)
      a_program_entry_for_session(p, another_session_for_presenter(program_entry.session.first_presenter))
      p.presentersInProgram.to_a.should == [program_entry.session.first_presenter]
    end
    it "for program with non-session entries does not return anything" do
      p = active_program_now
      program_entry = a_program_entry_for(p)
      a_program_entry_without_session_for(p)
      p.program_entries.size.should == 2
      p.presentersInProgram.to_a.should == [program_entry.session.first_presenter ]
    end
    def another_session_for_presenter(presenter)
      FactoryGirl.create(:session, :first_presenter_email => presenter.email )
    end
    def a_program_entry_for(program)
      FactoryGirl.create(:program_entry, :program => program)
    end
    def a_program_entry_for_session_with_2_presenters(program)
      a_program_entry_for_session(program, FactoryGirl.create(:session_with_2_presenters) )
    end
    def a_program_entry_for_session(program, session)
      FactoryGirl.create(:program_entry, :program => program, :session => session)
    end
    def a_program_entry_without_session_for(program)
      FactoryGirl.create(:program_entry, :program => program, :session => nil)
    end
  end

  describe "generate_pdf" do
    it "returns emtpy pdf for empty program" do 
      pdf = program.generate_pdf("tmp/program_test.pdf")
      pdf.should_not be_nil
      pdf.class.should equal File
    end
  end

  describe "generate_csv" do
    def a_program_entry_with_session_for(program)
      FactoryGirl.create(:program_entry, :program => program)
    end
    it "returns emtpy csv for empty program" do 
      csv = program.generate_csv
      csv.should == "Id;Slot;Track;Title;Subtitle;Presenter 1;Presenter 2;Type;Topic;Duration\n"
    end
    it "returns valid csv with 9 columns for empty program" do 
      a_program_entry_with_session_for(program)
      csv = program.generate_csv
      csv.should =~ /\n(.*;){9}[^;]*\n/
    end
  end

  describe "program_entries_for_topic" do
    def a_program_entry_for(program, topic)
      session_for_topic = FactoryGirl.create(:session_with_presenter, :topic => topic)
      FactoryGirl.create(:program_entry, :program => program, :session => session_for_topic)
    end
    def a_program_entry_without_session_for(program)
      FactoryGirl.create(:program_entry, :program => program, :session => nil)
    end
    context "with nil parameter" do
      it "returns emtpy list for empty program" do 
        program_entries = program.program_entries_for_topic(nil)
        program_entries.should be_empty
      end
      it "returns all program_entries with a session for program with sessions" do 
        pe = a_program_entry_for(program,"blabla")
        program_entries = program.program_entries_for_topic(nil)
        program_entries.should_not be_empty
        program_entries.size.should be(1)
        program_entries.should include(pe)
      end
      it "returns no program_entries that have no session" do 
        a_program_entry_without_session_for(program)
        program_entries = program.program_entries_for_topic(nil)
        program_entries.should be_empty
      end
    end
    context "with unexisting topic as a parameter" do
      it "returns emtpy list for empty program" do 
        program_entries = program.program_entries_for_topic("blabla")
        program_entries.should be_empty
      end
      it "returns emtpy list even for program with sessions with that unexisting topic" do 
        pe = a_program_entry_for(program,"blabla")
        program_entries = program.program_entries_for_topic("blabla")
        program_entries.should be_empty
      end
    end
    context "with existing topic as a parameter" do
      it "returns emtpy list for empty program" do 
        program_entries = program.program_entries_for_topic("technology")
        program_entries.should be_empty
      end
      it "returns emtpy list for program with sessions with only other topics" do 
        pe = a_program_entry_for(program,"Technology stuvv")
        program_entries = program.program_entries_for_topic("process")
        program_entries.should be_empty
      end
      it "returns program_entries for program that has sessions with chosen topic" do 
        pe1 = a_program_entry_for(program,"Methodology and improvement ")
        pe2 = a_program_entry_for(program,"Process and other thngs ")
        program_entries = program.program_entries_for_topic("process")
        program_entries.should_not be_empty
        program_entries.size.should be(2)
        program_entries.should include(pe1)
        program_entries.should include(pe2)
      end
      it "returns no program_entries that have no session" do 
        a_program_entry_without_session_for(program)
        program_entries = program.program_entries_for_topic("process")
        program_entries.should be_empty
      end
    end
    context "with other as a parameter" do
      it "returns program_entries for program that has sessions with non-standard topic" do 
        pe = a_program_entry_for(program,"special")
        program_entries = program.program_entries_for_topic("other")
        program_entries.should_not be_empty
        program_entries.size.should be(1)
        program_entries.should include(pe)
      end
    end
  end

  describe "room_for_program_entry" do
    context "for program that does not have a room-row"  do
      it "returns default " do 
        pe = a_program_entry_in_slot_and_track(program, 2, 2)
        program.room_for_program_entry(pe).should == "<TODO>"
      end
    end
    context "for program with room-row"  do
      def room_description_for(program, track, description)
        FactoryGirl.create(:program_entry_wo_session, :program => program, :slot => program.room_row, :track => track, :comment => description) 
      end
      it "returns default if room-row does not contain comment for program-entry" do 
        program.room_row = 1
        pe = a_program_entry_in_slot_and_track(program, 2, 2)
        program.room_for_program_entry(pe).should == "<TODO>"
      end
      it "returns given room if room-row does contain comment for program-entry" do 
        program.room_row = 1
        room_description_for(program, 3, "Fabulous Room" )
        pe = a_program_entry_in_slot_and_track(program, 2, 3)
        program.program_entries.size.should == 2
        program.room_for_program_entry(pe).should == "Fabulous Room"
      end
    end
  end

  describe "hour_for_program_entry" do
    context "for program that does not have a hour-column"  do
      it "returns default " do 
        pe = a_program_entry_in_slot_and_track(program, 2, 2)
        program.hour_for_program_entry(pe).should == "99:99 - 99:99"
      end
    end
    context "for program with hour-columb"  do
      def hour_description_for(program, slot, description)
        FactoryGirl.create(:program_entry_wo_session, :program => program, :slot => slot, :track => program.hour_column, :comment => description) 
      end
      it "returns default if hour-column does not contain comment for program-entry" do 
        program.hour_column = 1
        pe = a_program_entry_in_slot_and_track(program, 2, 2)
        program.hour_for_program_entry(pe).should == "99:99 - 99:99"
      end
      it "returns given hour if hour-column does contain all info for program-entry" do 
        program.hour_column = 0
        hour_description_for(program, 2, "8:25" )
        hour_description_for(program, 3, "10:55" )
        pe = a_program_entry_in_slot_and_track(program, 2, 3)
        program.program_entries.size.should == 3
        program.hour_for_program_entry(pe).should == "8:25 - 10:55" 
      end
      it "returns given hour if hour-column does contain starting hour but not ending hour" do 
        program.hour_column = 0
        hour_description_for(program, 2, "8:25" )
        pe = a_program_entry_in_slot_and_track(program, 2, 3)
        program.program_entries.size.should == 2
        program.hour_for_program_entry(pe).should == "8:25 - 99:99" 
      end
      it "returns given hour if hour-column does contain ending hour but not starting hour" do 
        program.hour_column = 0
        hour_description_for(program, 3, "10:55" )
        pe = a_program_entry_in_slot_and_track(program, 2, 3)
        program.program_entries.size.should == 2
        program.hour_for_program_entry(pe).should == "99:99 - 10:55" 
      end
    end
  end
end
