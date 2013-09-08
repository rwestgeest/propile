class AddSessionState < ActiveRecord::Migration
  def change
    add_column :sessions, :state, :integer, :null => false, :default => 0
  end
end
