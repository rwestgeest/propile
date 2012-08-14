class Presenter < ActiveRecord::Base
  EMAIL_REGEXP = /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i
  has_many :first_presenter_sessions, :class_name => 'Session', :foreign_key => :first_presenter_id
  has_many :second_presenter_sessions, :class_name => 'Session', :foreign_key => :second_presenter_id
  has_many :reviews
  has_many :comments
  has_many :votes
  belongs_to :account

  attr_accessible :bio, :email, :name

  validates :email, :presence => true,
                    :format => { :with => EMAIL_REGEXP }

  delegate :email, :to => :lazy_account, :allow_nil => true
  delegate :email=, :to => :lazy_account

  def initialize(*args)
    super(*args)
    lazy_account
  end

  def name
    if super.nil? || super.empty? then email else super end
  end

  def sessions
    first_presenter_sessions + second_presenter_sessions
  end

  def has_session?(session_id)
    first_presenter_sessions.find_by_id(session_id) || second_presenter_sessions.find_by_id(session_id)
  end

  def has_review?(review_id)
    reviews.find_by_id(review_id) 
  end

  def has_comment?(comment_id)
    comments.find_by_id(comment_id) 
  end

  def lazy_account
    self.account ||= Account.new
  end

end
