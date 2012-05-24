class Review < ActiveRecord::Base
  belongs_to :session
  belongs_to :presenter
  attr_accessible :body, :score
# attr_accessible :session, :presenter

  validates :body, :presence => true
#  validates :presenter, :presence => true
#  validates :session, :presence => true


end
