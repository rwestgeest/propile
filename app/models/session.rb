class Session < ActiveRecord::Base
  has_and_belongs_to_many :presenters
  attr_accessible :description, :title, :first_presenter_email, :second_presenter_email 
  attr_accessor :first_presenter_email, :second_presenter_email 
end
