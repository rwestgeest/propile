class AddXpFactorToReview < ActiveRecord::Migration
  def change
    add_column :reviews, :xp_factor, :integer, :null => false, :default => 0
  end
end
