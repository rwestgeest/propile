class Review < ActiveRecord::Base
  belongs_to :session
  belongs_to :presenter 
  has_many :comments
  attr_accessible :things_i_like, :things_to_improve, :score
  attr_accessible :session_id

  validates :things_i_like, :presence => true
  validates :things_to_improve, :presence => true
  validates :presenter, :presence => true
  validates :session, :presence => true

end
