class SessionMaterials < ActiveRecord::Migration
  def up
    add_column :sessions, :material_description, :string, :limit => 128
    add_column :sessions, :material_url, :string, :limit => 1024
  end

  def down
    drop_column :sessions, :material_description
    drop_column :sessions, :material_url
  end
end
