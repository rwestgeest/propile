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
  def session_submit(presenter_email, presenter_login_guid, session)
    @greeting = "Hi"
    @login_guid = presenter_login_guid
    @session = session
    mail to: presenter_email
  end
end
