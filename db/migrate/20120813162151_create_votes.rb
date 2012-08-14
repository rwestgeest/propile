class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :session
      t.references :presenter

      t.timestamps
    end
    add_index :votes, :session_id
    add_index :votes, :presenter_id
  end
end
