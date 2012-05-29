class Presenter < ActiveRecord::Base
  has_and_belongs_to_many :sessions
  has_many :reviews
  belongs_to :account

  attr_accessible :bio, :email, :name

  validates_presence_of :email

  delegate :email, :to => :lazy_account, :allow_nil => true
  delegate :email=, :to => :lazy_account

  def initialize(*args)
    super(*args)
    lazy_account
  end

  def name
    super || email
  end

  def lazy_account
    self.account ||= Account.new
  end

end
