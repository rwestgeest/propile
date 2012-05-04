class Session < ActiveRecord::Base
  has_and_belongs_to_many :presenters
  attr_accessible :description, :title, :first_presenter_email, :second_presenter_email 
  attr_accessor :second_presenter_email 

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

end
