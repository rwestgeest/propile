require 'prawn'
require 'pdf_helper'

class Session < ActiveRecord::Base
  AVAILABLE_TOPICS_AND_NAMES = { "technology"=>"Technology and Technique", 
                                 "customer"=>"Customer and Planning", 
                                 "cases"=>"Intro's and Cases", 
                                 "team"=>"Team and Individual", 
                                 "process"=>"Process and Improvement", 
                                 "other"=>"Other"}
  AVAILABLE_TOPICS_AND_NAMES_FOR_SELECT = AVAILABLE_TOPICS_AND_NAMES.invert
  AVAILABLE_TOPICS = AVAILABLE_TOPICS_AND_NAMES.keys
  AVAILABLE_TOPIC_NAMES = AVAILABLE_TOPICS_AND_NAMES.values
  AVAILABLE_LAPTOPS_REQUIRED = { "no" => "no", "yes" => "yes"}
  AVAILABLE_DURATION = [ "60 min", "90 min", "120 min", "180 min" ]


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
  validates :topic, :inclusion => { :in => AVAILABLE_TOPICS_AND_NAMES_FOR_SELECT.values, :message => "has invalid value: %{value}. Enter a valid topic." }, :allow_blank => true
  validates :laptops_required, :inclusion => { :in => AVAILABLE_LAPTOPS_REQUIRED.values, :message => "has invalid value: %{value}. Enter yes or no." }, :allow_blank => true 
  validates :duration, :inclusion => { :in => AVAILABLE_DURATION, :message => "has invalid value: %{value}. " }, :allow_blank => true 

  public
  def first_presenter_email
    first_presenter && first_presenter.email || ''
  end

  def second_presenter_email
    second_presenter && second_presenter.email || ''
  end
  def first_presenter_email=(value)
    return unless value and not value.empty? #not allowed to remove first presenter
    self.first_presenter = Presenter.includes(:account).where('lower(accounts.email) = ?', value.downcase).first  || Presenter.create_from_archived_presenter(value)
  end

  def second_presenter_email=(value)
    if value.nil? or value.empty?
      self.second_presenter = nil 
    else
      self.second_presenter = Presenter.includes(:account).where('lower(accounts.email) = ?', value.downcase).first  || Presenter.create_from_archived_presenter(value)
    end
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

  def self.topic_name(topic)
    AVAILABLE_TOPICS_AND_NAMES[topic] || ""
  end

  def topic_name
    Session.topic_name(topic) 
  end

  def printable_max_participants
    (!max_participants.nil? and !max_participants.empty?  and max_participants.to_i>0) ?  "Max: " + max_participants.to_i.to_s : ""
  end

  def printable_laptops_required
    (laptops_required and laptops_required == "yes") ?  "bring laptop" : ""
  end

  def program_card_content(pdf, room="<TODO>", hour="99:99 - 99:99")
    pdf.font_size 10
    pdf.text hour, :align => :center
    pdf.move_up 12
    pdf.text id.to_s, :align => :right
    pdf.bounding_box([0, 245], :width => 380) do 
      pdf.text title, :align => :center, :size => 18
      pdf.text sub_title, :align => :center, :style => :italic, :size => 8
    end
    pdf.bounding_box([0, 190], :width => 380) do 
      PdfHelper.new().wikinize_for_pdf(short_description, pdf) if !short_description.nil? 
    end
    pdf.bounding_box([0, 29], :width => 380, :height => 36 ) do 
      pdf.text "Presenters:"
      pdf.text "Format: "
      pdf.text "Room: "
    end
    pdf.bounding_box([60, 29], :width => 320, :height => 36 ) do 
      pdf.text presenter_names
      pdf.text session_type.truncate(60)if !session_type.nil? 
      pdf.text room
    end
    pdf.bounding_box([300, 29], :width => 80, :height => 36 ) do 
      pdf.text printable_max_participants, :align => :right
      pdf.text printable_laptops_required, :align => :right
    end
  end

  def generate_program_board_card_pdf(file_name)
    Prawn::Document.generate file_name, 
                    :page_size => 'A6', :page_layout => :landscape, 
                    :top_margin => 10, :bottom_margin => 10, 
                    :left_margin => 20, :right_margin => 20 do |pdf| 
      program_card_content(pdf)
    end
  end

  def printable_description_content(pdf, room="<TODO>", hour="99:99 - 99:99")
    pdf.font_size 12
    pdf.text hour, :align => :center
    pdf.move_up 14
    pdf.text id.to_s, :align => :right
    pdf.bounding_box([0, 800], :width => 550) do 
      pdf.text title, :align => :center, :size => 24
      pdf.text sub_title, :align => :center, :style => :italic, :size => 14
    end
    pdf.bounding_box([0, 700], :width => 550) do 
      PdfHelper.new().wikinize_for_pdf(description, pdf)
    end
    pdf.bounding_box([0, 58], :width => 380, :height => 58 ) do 
      pdf.text "Presenters:"
      pdf.text "Format: "
      pdf.text "Topic: "
      pdf.text "Room: "
    end
    pdf.bounding_box([70, 58], :width => 320, :height => 58 ) do 
      pdf.text presenter_names
      pdf.text session_type.truncate(60) unless session_type.nil? 
      pdf.text topic_name 
      pdf.text room
    end
    pdf.bounding_box([480, 58], :width => 80, :height => 58 ) do 
      pdf.text printable_max_participants, :align => :right
      pdf.text printable_laptops_required, :align => :right
    end
  end

  def generate_pdf(file_name)
    Prawn::Document.generate file_name, 
                    :page_size => 'A4', :page_layout => :portrait, 
                    :top_margin => 10, :bottom_margin => 10, 
                    :left_margin => 20, :right_margin => 20 do |pdf| 
      printable_description_content(pdf)
    end
  end

end
