require 'authenticable'

class Account < ActiveRecord::Base
  Maintainer = "maintainer"
  Presenter = "presenter"

  include Authenticable 
  on_account_reset :send_reset_message

  before_create :generate_authentication_token

  attr_accessible :email, :password, :password_confirmation, :role, :last_login

  has_one :presenter

  attr_accessor :password
  validates_confirmation_of :password

  def maintainer?
    role == Maintainer
  end

  def maintainer= becomes_maintainer
    self.role =  becomes_maintainer ? Maintainer : Presenter 
  end

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
    return '/account/password/edit' if !confirmed? || reset?
    return '/sessions'
  end

end
