class AddLinksToPresenter < ActiveRecord::Migration
  def change
    add_column :presenters, :twitter_id, :string, :limit => 128
    add_column :presenters, :profile_image, :string, :limit => 1024
    add_column :presenters, :website, :string, :limit => 1024
  end
end
