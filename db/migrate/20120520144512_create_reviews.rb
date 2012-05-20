class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.text :body
      t.integer :score
      t.references :session
      t.references :presenter

      t.timestamps
    end
    add_index :reviews, :session_id
    add_index :reviews, :presenter_id
  end
end
