class Notifications < ActionMailer::Base
  FromAddress = "sessions@xpday.net"
  default from: FromAddress

  def account_reset(account)
    @account = account
    mail to: account.email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications.session_submit.subject
  #
  def session_submit(presenter, session)
    @greeting = "Hi"
    @login_guid = presenter.account.authentication_token
    @session = session
    mail to: presenter.email
  end

  def review_creation(email, review)
    @review = review
    @session= review.session
    mail to: email, :subject => "Review on session '#{review.session.title}'"
  end
end
