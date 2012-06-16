class Comment < ActiveRecord::Base
  belongs_to :review
  belongs_to :presenter
  attr_accessible :body
  attr_accessible :review_id
  attr_accessible :presenter_id

  validates :body, :presence => true
  validates :review, :presence => true
  validates :presenter, :presence => true
end
