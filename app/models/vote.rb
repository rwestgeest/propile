class Vote < ActiveRecord::Base
  belongs_to :session
  belongs_to :presenter 

  attr_accessible :id, :session_id

  validates :presenter, :presence => true
  validates :session, :presence => true

  def self.presenter_has_voted_for?(presenter_id, session_id) 
    Vote.exists?( :presenter_id => presenter_id, :session_id => session_id ) 
  end
end
