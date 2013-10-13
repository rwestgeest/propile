require "prawn"
require 'prawn/measurement_extensions'
require 'csv'

class Program < ActiveRecord::Base
  attr_accessible :version
  attr_accessible :avgpaf
  attr_accessible :exported_at
  attr_accessible :room_row, :hour_column
  has_many :program_entries, :autosave => true, :dependent => :destroy

  def init_with_entries
    8.times {|slot| 
      5.times {|track| 
        pe = ProgramEntry.new
        pe.slot=slot+1
        pe.track=track+1
        program_entries<<pe
      }  
    }
  end 

  def sessionsInProgram
    program_entries.collect {|pe| pe.session }.select{|s| !s.nil?}
  end 

  def programEntriesForPresenter(presenter)
    program_entries.select{|pe| !pe.session.nil? and pe.session.presenters.include?(presenter)}
  end 

  def presentersInProgram
    program_entries.collect{|pe| if !pe.session.nil? then pe.session.presenters end }.flatten.select{|pr| !pr.nil?}.to_set
  end 

  def programEntryMatrix # rows=slots, cols=tracks
    return @matrix unless @matrix.nil?
    @matrix = Hash.new
    program_entries.each { |pe| @matrix[[pe.slot, pe.track]] = pe }
    @matrix
  end

  def switch_entries(old_slot, old_track, new_slot, new_track)
    entry_on_old_location = entry(old_slot, old_track)
    entry_on_new_location = entry(new_slot, new_track)

    if entry_on_new_location 
      entry_on_new_location.slot, entry_on_new_location.track = old_slot,old_track
    end
    if entry_on_old_location 
      entry_on_old_location.slot, entry_on_old_location.track = new_slot, new_track
    end
    @matrix=nil
    save
  end

  def maxSlot
    program_entries.collect{ |pe| pe.slot }.max || 0 
  end

  def eachSlot
    (1..maxSlot).each { |slot| yield(slot) }
  end

  def maxTrack
    program_entries.collect{ |pe| pe.track }.max || 0
  end

  def eachTrack
    (1..maxTrack).each { |track| yield(track) }
  end

  def entry(slot,track) 
    programEntryMatrix() [[slot,track]]
  end

  def insertSlot(beforeSlot)
    (beforeSlot..maxSlot).each do |slot|
      eachTrack do |track|
        program_entry = entry(slot,track)
        if !program_entry.nil?
          program_entry.slot += 1
        end
      end
    end
    self
  end

  def removeSlot(slotToRemove)
    (slotToRemove..maxSlot).each do |slot|
      eachTrack do |track|
        program_entry = entry(slot,track)
        if !program_entry.nil?
          if slot==slotToRemove 
            program_entry.mark_for_destruction 
          else
            program_entry.slot -= 1
          end
        end
      end
    end
    self
  end

  def insertTrack(beforeTrack)
    (beforeTrack..maxTrack).each do |track|
      eachSlot do |slot|
        program_entry = entry(slot,track)
        if !program_entry.nil?
          program_entry.track += 1
        end
      end
    end
    self
  end

  def removeTrack(trackToRemove)
    (trackToRemove..maxTrack).each do |track|
      eachSlot do |slot|
        program_entry = entry(slot,track)
        if !program_entry.nil?
          if track==trackToRemove 
            program_entry.mark_for_destruction 
          else
            program_entry.track -= 1
          end
        end
      end
    end
    self
  end

  def calculatePaf
    self.avgpaf = calculateAvgPafForPresenters(Presenter.voting_presenters)
  end

  def calculateAvgPafForPresenters(presenters)
    return 0 unless presenters and not presenters.empty?
    pafPerPresenter = calculatePafForPresenters(presenters)
    pafPerPresenter.inject {|sum,x| sum+x}  / pafPerPresenter.size
  end

  def calculatePafForPresenters(presenters)
    pafPerPresenter = []
    presenters.each do |presenter|
      pafPerPresenter.append calculatePafForOnePresenter(presenter.votes)
    end 
    pafPerPresenter
  end

  def calculatePafForOnePresenter(votes_by_presenter)
    slotsForPresenter = Set.new
    votes_by_presenter.each do |vote| 
      if program_entries.exists? :session_id => vote.session.id
        slotsForPresenter << program_entries.where(:session_id => vote.session.id).first.slot
      end
    end
    slotsForPresenter.size
  end

  def program_entries_for_topic(topic)
    program_entries.select{|pe| !pe.session.nil? and (topic.nil? or pe.session.topic==topic) } 
  end

  def room_for_program_entry(program_entry)
    room_description_entry = entry(room_row, program_entry.track) 
    room_description_entry.nil? ?  "<TODO>"  : room_description_entry.comment
  end

  def hour_for_program_entry(program_entry)
    starting_hour_description = entry(program_entry.slot, hour_column)
    ending_hour_description = entry(program_entry.slot+1, hour_column)
    starting_hour = starting_hour_description.nil? ?  "99:99" : starting_hour_description.comment
    ending_hour = ending_hour_description.nil? ?  "99:99" : ending_hour_description.comment
    "#{starting_hour} - #{ending_hour}"
  end

  def generate_pdf(file_name, topic=nil)
    Prawn::Document.generate file_name, 
                    :page_size => 'A4', :page_layout => :portrait, 
                    :top_margin => 3.5.mm, :bottom_margin => 3.5.mm, 
                    :left_margin => 7.mm, :right_margin => 7.mm do |pdf| 
      program_entries_for_topic(topic).each_with_index do |pe, i| 
        if !pe.session.nil?  
          pdf.start_new_page if i>0
          pe.session.printable_description_content(pdf, room_for_program_entry(pe), hour_for_program_entry(pe))
        end   
      end
    end
  end

  def generate_program_board_cards_pdf(file_name, topic=nil)
    Prawn::Document.generate file_name, 
                    :page_size => 'A6', :page_layout => :landscape, 
                    :top_margin => 3.5.mm, :bottom_margin => 3.5.mm, 
                    :left_margin => 7.mm, :right_margin => 7.mm do |pdf| 
      program_entries_for_topic(topic).each_with_index do |pe, i| 
        if !pe.session.nil?  
          pdf.start_new_page if i>0
          pe.session.program_board_card_content(pdf, room_for_program_entry(pe), hour_for_program_entry(pe)) 
          add_feedback_card_content(pdf) if !topic.nil?
        end   
      end
    end
  end

  def add_feedback_card_content(pdf) 
    pdf.start_new_page
    pdf.font_size 10
    pdf.bounding_box([0, 95.mm], :width =>135.mm ) do 
      pdf.text "<b>Feedback</b>", :align => :center, :size => 18, :inline_format => true
    end
    pdf.bounding_box([80.mm, 85.mm], :width => 50.mm) do 
      #pdf.stroke_bounds
      pdf.font_size 15
      pdf.font_size 15
      pdf.rotate(270, :origin => [25.mm,-25.mm]) do
        pdf.text "<b>:-(</b>", :align => :left, :inline_format => true
        pdf.text "   ", :align => :left
        pdf.text "<b>:-|</b>", :align => :left, :inline_format => true
        pdf.text "   ", :align => :left
        pdf.text "<b>:-)</b>", :align => :left, :inline_format => true
      end
    end
    pdf.font_size 10
    pdf.bounding_box([0, 75.mm], :width => 135.mm) do 
      pdf.text "<b>What I like about this session: </b>", :align => :justify, :inline_format => true
    end
    pdf.bounding_box([0, 40.mm], :width => 135.mm) do 
      pdf.text "<b>What I think you can improve: </b>", :align => :justify, :inline_format => true
    end
    pdf.bounding_box([0, 3.5.mm], :width => 135.mm) do 
      pdf.text "<i><font size='8'>the intention is that the session presenters can use your feedback to improve their session.</font></i> ", :align => :center, :inline_format => true 
    end
  end

  def generate_csv
    program_csv = CSV.generate(options = { :col_sep => ';' }) do |csv| 
      #header row
      csv << [ "Id", "Slot", "Track", 
               "Title", "Subtitle",
               "Presenter 1", "Presenter 2", 
               "Type", "Topic", "Duration" 
             ]
      #data row
      program_entries.each do |entry| 
        if ( !entry.session.nil? ) then
          csv << [ entry.session.id, entry.slot, entry.track,
                   entry.session.title, entry.session.sub_title, 
                   entry.session.first_presenter.name, (entry.session.second_presenter.nil? ? nil : entry.session.second_presenter.name), 
                   entry.session.session_type, entry.session.topic_name, entry.session.duration
                 ]
        end
      end
    end
  end

  def generate_materials_csv
    materials_csv = CSV.generate(options = { :col_sep => ';' }) do |csv| 
      #header row
      csv << [ "Id", 
               "Title", "Room", "Hour",
               "Max participants", "Laptops Required", "Other limitations", 
               "Room setup", "Materials needed", "Intended audience"
             ]
      #data row
      program_entries.each do |entry|
        session = entry.session
        if !session.nil? then
          room = room_for_program_entry(entry)
          hour = hour_for_program_entry(entry)
          csv << [ session.id, 
                   session.title, room, hour, 
                   session.max_participants, session.laptops_required, session.other_limitations, 
                   session.room_setup, session.materials_needed, session.intended_audience
                 ]
        end
      end
    end
  end

end
