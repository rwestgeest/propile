class ArchivedPresenter < ActiveRecord::Base
  attr_accessible :bio, :email, :name
  attr_accessible :twitter_id, :profile_image, :website

  validates :email, :presence => true

  def fill_from (presenter)
    if presenter
      self.bio =  presenter.bio
      self.email = presenter.email
      self.name = presenter.name
      self.twitter_id = presenter.twitter_id
      self.profile_image = presenter.profile_image
      self.website = presenter.website
    end
    self
  end
end
