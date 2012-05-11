class Notifications < ActionMailer::Base
  FromAddress = "sessions@xpday.net"
  default from: FromAddress

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications.session_submit.subject
  #
  def session_submit(presenter_email, session)
    @greeting = "Hi"
    @session = session
    mail to: presenter_email
  end
end
