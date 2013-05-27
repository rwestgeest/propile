class ArchivedPresenter < ActiveRecord::Base
  attr_accessible :bio, :email, :name

  validates :email, :presence => true

  def fill_from (presenter)
    if presenter
      self.bio =  presenter.bio
      self.email = presenter.email
      self.name = presenter.name
    end
    self
  end
end
