require "prawn"

class Program < ActiveRecord::Base
  attr_accessible :version
  attr_accessible :avgpaf
  attr_accessible :activation
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

  def activate
    self.activation = DateTime.now
    self
  end

  def self.activeProgram
    Program.all.max { |p1, p2| 
      p1.activation.nil? ? -1 : 
        ( p2.activation.nil? ? 1 : 
          ( p1.activation <=> p2.activation )
        )
    }
  end

  def sessionsInProgram
    program_entries.collect{|pe| if !pe.session.nil? then pe.session end } 
  end 

  def presentersInProgram
    program_entries.collect{|pe| if !pe.session.nil? then pe.session.presenters end }.flatten.select{|pr| !pr.nil?}.to_set
  end 

  def active?
    return false unless !activation.nil? 
    self == Program.activeProgram
  end

  def programEntryMatrix # rows=slots, cols=tracks
    return @matrix unless @matrix.nil?
    @matrix = Hash.new
    program_entries.each { |pe| @matrix[[pe.slot, pe.track]] = pe }
    @matrix
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
    return program_entries if topic.nil? 
    program_entries.select{|pe| if !pe.session.nil? and !topic.nil? and pe.session.topic_class==topic then pe end } 
  end

  def generate_pdf(file_name)
    Prawn::Document.generate file_name, 
                    :page_size => 'A4', :page_layout => :portrait, 
                    :top_margin => 10, :bottom_margin => 10, 
                    :left_margin => 20, :right_margin => 20 do |pdf| 
      program_entries.each do |pe| 
        if !pe.session.nil?  
          pe.session.printable_description_content(pdf)
          pdf.start_new_page
        end   
      end
    end
  end

  def generate_program_board_cards_pdf(file_name, topic=nil)
    Prawn::Document.generate file_name, 
                    :page_size => 'A6', :page_layout => :landscape, 
                    :top_margin => 10, :bottom_margin => 10, 
                    :left_margin => 20, :right_margin => 20 do |pdf| 
      program_entries_for_topic(topic).each do |pe| 
        if !pe.session.nil?  
          pe.session.program_card_content(pdf) 
          pdf.start_new_page
          if !topic.nil?
            feedback_card_content(pdf) 
            pdf.start_new_page
          end
        end   
      end
    end
  end

  def feedback_card_content(pdf) 
    pdf.font_size 10
    pdf.bounding_box([0, 270], :width => 380) do 
      pdf.text "Feedback: the Perfection Game", :align => :center, :size => 18
      #pdf.text "the intention is that the session presenters can use your feedback to improve their session. ", :align => :center, :style => :italic, :size => 8
      pdf.text "<i><font size='8'>the intention is that the session presenters can use your feedback to improve their session.</font></i> ", :align => :center, :inline_format => true 
    end
    pdf.bounding_box([0, 230], :width => 380) do 
      pdf.text "I give this session a ....... / 10<i><font size='8'> (this means that you, having participated in this session, think that the session can be improved to get a 10/10. You will list those possible improvements below.) </font></i> ", :align => :justify, :inline_format => true 
    end
    pdf.bounding_box([0, 190], :width => 380) do 
      pdf.text "What I like: <i><font size='8'> first list the things that you like about this session, why did it get the score you gave it?</font></i> ", :align => :justify, :inline_format => true
    end
    pdf.bounding_box([0, 100], :width => 380) do 
      pdf.text "I will give you a 10/10 if you improve these things: <i><font size='8'> list improvements to the session: what does the session presenters need to change so that you will give them a 10/10?</font></i> ", :align => :justify, :inline_format => true
    end
  end

end
