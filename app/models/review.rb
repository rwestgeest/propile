class Review < ActiveRecord::Base
  belongs_to :session
  belongs_to :presenter 
  has_many :comments
  attr_accessible :body, :score
  attr_accessible :session_id

  validates :body, :presence => true
  validates :presenter, :presence => true
  validates :session, :presence => true

end
