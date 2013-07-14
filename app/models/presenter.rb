class Presenter < ActiveRecord::Base
  EMAIL_REGEXP = /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i
  has_many :first_presenter_sessions, :class_name => 'Session', :foreign_key => :first_presenter_id
  has_many :second_presenter_sessions, :class_name => 'Session', :foreign_key => :second_presenter_id
  has_many :reviews
  has_many :comments
  has_many :votes
  belongs_to :account

  attr_accessible :bio, :email, :name, :role

  validates :email, :presence => true,
                    :format => { :with => EMAIL_REGEXP }

  delegate :email, :to => :lazy_account, :allow_nil => true
  delegate :email=, :to => :lazy_account

  delegate :role, :to => :lazy_account, :allow_nil => true
  delegate :role=, :to => :lazy_account

  def self.voting_presenters
    all.select {|p| !p.votes.empty? }
  end

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

  def has_vote?(vote_id)
    votes.find_by_id(vote_id) 
  end

  def sessions_reviewed
    reviews.collect { |r|  r.session }.compact
  end

  def sessions_involved
    (sessions + reviews.collect{|r| r.session }  + comments.collect {|c| c.review.session}).uniq.compact
  end

  def lazy_account
    self.account ||= Account.new
  end


  def self.archive_all
    self.all.each do |presenter|
      archived = ArchivedPresenter.find_by_email(presenter.email) || ArchivedPresenter.new
      archived.fill_from(presenter)
      archived.save
      if  !presenter.account.maintainer? 
        presenter.account.destroy
        presenter.destroy
      end
    end
  end

  def self.create_from_archived_presenter(email_value)
    if archived_presenter = ArchivedPresenter.where('lower(email) = ?', email_value.downcase).first
      presenter = Presenter.new(:email => email_value, :name => archived_presenter.name, :bio => archived_presenter.bio)
    else
      presenter = Presenter.new(:email => email_value)
    end
  end

end
