class Presenter < ActiveRecord::Base
  has_many :first_presenter_sessions, :class_name => 'Session', :foreign_key => :first_presenter_id
  has_many :second_presenter_sessions, :class_name => 'Session', :foreign_key => :second_presenter_id
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

  def sessions
    first_presenter_sessions + second_presenter_sessions
  end

  def lazy_account
    self.account ||= Account.new
  end

end
