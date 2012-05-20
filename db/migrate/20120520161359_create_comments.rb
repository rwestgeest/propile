class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body
      t.references :review
      t.references :presenter

      t.timestamps
    end
    add_index :comments, :review_id
    add_index :comments, :presenter_id
  end
end
