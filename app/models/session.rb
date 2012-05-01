class Session < ActiveRecord::Base
  has_and_belongs_to_many :presenters
  attr_accessible :description, :title
end
