class Review < ActiveRecord::Base
  belongs_to :session
  belongs_to :presenter 
  has_many :comments
  attr_accessible :things_i_like, :things_to_improve, :score
  attr_accessible :session_id

  validates :things_i_like, :presence => true
  validates :things_to_improve, :presence => true, :unless => :max_score? 
  validates :presenter, :presence => true
  validates :session, :presence => true
  validates :score, :presence => true
  validates_numericality_of :score

  validate :no_things_to_improve_when_max_score
   
  def no_things_to_improve_when_max_score
    if max_score? and !things_to_improve.blank?
      errors.add(:things_to_improve, "can't be filled in when the score is 10/10. ")
    end
  end

  def max_score?
    score == 10
  end
end
