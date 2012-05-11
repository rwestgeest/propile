class AddLoginGuidToPresenters < ActiveRecord::Migration
  def change
    add_column :presenters, :login_guid, :string
  end
end
