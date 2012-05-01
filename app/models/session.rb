class Session < ActiveRecord::Base
  has_and_belongs_to_many :presenters
  attr_accessible :description, :title, :first_presenter_email, :second_presenter_email 
  attr_accessor :second_presenter_email 

  def first_presenter_email
    @first_presenter_email
  end

  def first_presenter_email=(value)
    @first_presenter_email= value
    presenters << Presenter.new(:email => value)
  end
  def second_presenter_email=(value)
    return unless value
    @second_presenter_email= value
    presenters << Presenter.new(:email => value)
  end

end
