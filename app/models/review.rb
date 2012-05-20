class Review < ActiveRecord::Base
  belongs_to :session
  belongs_to :presenter
  attr_accessible :body, :score

  validates :body, :presence => true
#  validates :presenter, :presence => true
#  validates :session, :session => true
end
