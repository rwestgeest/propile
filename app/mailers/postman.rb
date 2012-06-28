class Postman
  def self.deliver(message, *args)
    Notifications.send(message, *args).deliver
  end
  def self.notify_review_creation(review)
    ([ review.presenter ] + review.session.presenters).each do |presenter|
      deliver(:review_creation, presenter.email, review)
    end
  end
  def self.notify_comment_creation(comment)
    ([comment.presenter, comment.review.presenter] + comment.review.session.presenters).each do |presenter|
      deliver( :comment_creation, presenter.email, comment )
    end
  end
end


