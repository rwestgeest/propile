class Presenter < ActiveRecord::Base
  has_and_belongs_to_many :sessions
  has_many :reviews
  belongs_to :account

  attr_accessible :bio, :email, :name

  delegate :email, :to => :lazy_account, :allow_nil => true
  delegate :email=, :to => :lazy_account

  private
  def lazy_account
    self.account ||= Account.new
  end
end
