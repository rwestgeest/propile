class Session < ActiveRecord::Base
  belongs_to :first_presenter, :class_name => 'Presenter'
  belongs_to :second_presenter, :class_name => 'Presenter'

  has_many :reviews
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
end
