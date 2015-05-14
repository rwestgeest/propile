class AddXpFactorToSession < ActiveRecord::Migration
  def change
    add_column :sessions, :xp_factor, :integer, :null => false, :default => 0
  end
end
