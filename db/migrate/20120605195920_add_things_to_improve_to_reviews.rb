class AddThingsToImproveToReviews < ActiveRecord::Migration
  def change
    rename_column :reviews, :body, :things_i_like
    add_column :reviews, :things_to_improve, :text
  end
end
