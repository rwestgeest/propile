class Postman
  def self.deliver(message, *args)
    Notifications.send(message, *args).deliver
  end
end

