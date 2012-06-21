require 'recaptcha'
class Captcha
  def self.verified?(controller)
    controller.verify_recaptcha
  end
end

