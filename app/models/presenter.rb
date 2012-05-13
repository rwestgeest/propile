class Presenter < ActiveRecord::Base
  has_and_belongs_to_many :sessions
  attr_accessible :bio, :email, :name, :login_guid
  
end
