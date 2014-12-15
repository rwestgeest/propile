class AddFieldsToArchivedPresenter < ActiveRecord::Migration
  def change
    add_column :archived_presenters, :twitter_id, :string, :limit => 128
    add_column :archived_presenters, :profile_image, :string, :limit => 1024
    add_column :archived_presenters, :website, :string, :limit => 1024
  end
end
