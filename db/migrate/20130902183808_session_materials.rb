class SessionMaterials < ActiveRecord::Migration
  def change
    add_column :sessions, :material_description, :string, :limit => 128
    add_column :sessions, :material_url, :string, :limit => 1024
  end
end
