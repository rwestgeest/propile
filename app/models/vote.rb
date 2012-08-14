class Vote < ActiveRecord::Base
  belongs_to :session
  belongs_to :presenter 

  attr_accessible :id, :session_id

  validates :presenter, :presence => true
  validates :session, :presence => true
end
