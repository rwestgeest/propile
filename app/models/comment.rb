class Comment < ActiveRecord::Base
  belongs_to :review
  belongs_to :presenter
  attr_accessible :body

  validates :body, :presence => true
#  validates :review, :presence => true
#  validates :presenter, :presenter => true
end
