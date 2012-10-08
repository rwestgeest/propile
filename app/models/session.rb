require 'prawn'

class Session < ActiveRecord::Base
  belongs_to :first_presenter, :class_name => 'Presenter'
  belongs_to :second_presenter, :class_name => 'Presenter'

  has_many :reviews
  has_many :votes
  attr_accessible :description, :title, :first_presenter_email, :second_presenter_email 
  attr_accessible :sub_title, :short_description, :session_type, :topic
  attr_accessible :duration, :intended_audience, :experience_level
  attr_accessible :max_participants, :laptops_required, :other_limitations, :room_setup, :materials_needed
  attr_accessible :session_goal, :outline_or_timetable

  validates :title, :presence => true
  validates :description, :presence => true
  validates :first_presenter, :presence => true
  validates :first_presenter_email, :format => { :with => Presenter::EMAIL_REGEXP }
  validates :second_presenter_email, :format => { :with => Presenter::EMAIL_REGEXP }

  def first_presenter_email
    first_presenter && first_presenter.email || ''
  end

  def second_presenter_email
    second_presenter && second_presenter.email || ''
  end

  def first_presenter_email=(value)
    return unless value and not value.empty?
    self.first_presenter = Presenter.includes(:account).where('lower(accounts.email) = ?', value.downcase).first || Presenter.new(:email => value)
  end

  def second_presenter_email=(value)
    return unless value and not value.empty?
    self.second_presenter = Presenter.includes(:account).where('lower(accounts.email) = ?', value.downcase).first || Presenter.new(:email => value)
  end

  def presenter_names
    presenters.collect {|presenter| presenter.name }.join(' & ')
  end

  def presenters 
    [ first_presenter, second_presenter ].compact
  end

  def presenter_has_voted_for?(presenter_id) 
    votes.exists?( :presenter_id => presenter_id ) 
  end

  def in_active_program?
    active_program = Program.activeProgram
    active_program.nil? ? false : active_program.sessionsInProgram.include?(self)
  end

  def topic_class
    return "" if topic.nil?
    topic_downcase = topic.downcase
    topic_class = case
      when topic_downcase.include?("techn")  then "technology"
      when topic_downcase.include?("customer") || topic.include?("planning")  then "customer"
      when topic_downcase.include?("case") || topic.include?("intro")  then "cases"
      when topic_downcase.include?("team") || topic.include?("individual")  then "team"
      when topic_downcase.include?("process") || topic.include?("improv")  then "process"
      else ""
    end
  end

  def generatePdf(file_name)
    Prawn::Document.generate file_name, 
                    :page_size => 'A6', :page_layout => :landscape, 
                    :top_margin => 10, :bottom_margin => 10, 
                    :left_margin => 20, :right_margin => 20 do |pdf| 
      generatePdfContent(pdf)
    end
  end

  def printable_max_participants
    if !max_participants.nil? and !max_participants.empty?  and max_participants.to_i>0
	"Max: " + max_participants.to_i.to_s
    end
  end

  def generatePdfContent(pdf)
    pdf.font_size 10
    pdf.text "99:99 - 99:99", :align => :center
    pdf.bounding_box([0, 250], :width => 380) do 
      pdf.text title, :align => :center, :size => 18
      pdf.text sub_title, :align => :center, :style => :italic, :size => 8
    end
    pdf.bounding_box([0, 190], :width => 380) do 
      pdf.text short_description, :align => :justify if !short_description.nil? 
    end
    pdf.draw_text "Presenters:", :at => [0, 29], :width => 60
    pdf.draw_text "Format: ", :at => [0, 17], :width => 60 
    pdf.draw_text "Room: ", :at => [0, 5], :width => 60 
    pdf.draw_text presenter_names, :at => [60, 29], :width => 320
    pdf.draw_text session_type, :at => [60, 17], :width => 320
    pdf.draw_text "<todo>", :at => [60, 5], :width => 320
    pdf.draw_text printable_max_participants, :at => [345, 29] 
  end
end
