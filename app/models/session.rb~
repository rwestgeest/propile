class Session < ActiveRecord::Base
  has_and_belongs_to_many :presenters
  has_many :reviews
  attr_accessible :description, :title, :first_presenter_email, :second_presenter_email 
  attr_accessor :second_presenter_email 
  attr_accessible :sub_title, :short_description, :session_type, :topic
  attr_accessible :duration, :intended_audience, :experience_level
  attr_accessible :max_participants, :laptops_required, :other_limitations, :room_setup, :materials_needed
  attr_accessible :session_goal, :outline_or_timetable

  validates :title, :presence => true
  validates :description, :presence => true
  validates :presenters, :presence => true

  def first_presenter_email
    presenters.first && presenters.first.email || ''
  end

  def second_presenter_email
    presenters[1] && presenters[1].email || ''
  end

  def first_presenter_email=(value)
    presenters << Presenter.new(:email => value)
  end

  def second_presenter_email=(value)
    return if !value || value.strip.empty?
    presenters << Presenter.new(:email => value)
  end

  def presenter_names
    s = presenters.first && ( presenters.first.name || presenters.first.email ) || ''
    s += presenters[1] && (" & " + ( presenters[1].name || presenters[1].email ) ) || ''
    s
  end
end
