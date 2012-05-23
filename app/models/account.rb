class Account < ActiveRecord::Base
  Maintainer = "maintainer"
  Submitter = "submitter"

  belongs_to :person
  attr_accessible :authentication_token, :confirmed_at, :login, :encrypted_password, :password_salt, :role

end
