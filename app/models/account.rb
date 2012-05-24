require 'authenticable'

class Account < ActiveRecord::Base
  Maintainer = "maintainer"
  Submitter = "submitter"

  include Authenticable 
  on_account_reset :send_reset_message

  before_create :generate_authentication_token

  attr_accessible :email, :password, :password_confirmation, :role

  belongs_to :person

  attr_accessor :password
  validates_confirmation_of :password

  def send_reset_message
    Postman.deliver(:account_reset, self)
  end

  def generate_authentication_token
    while (true) 
      self.authentication_token = TokenGenerator.generate_token
      return authentication_token if unique_token?(authentication_token)
    end
  end

  def landing_page
    '/account/password/edit'
  end
end
