class CreatePresenters < ActiveRecord::Migration
  def change
    create_table :presenters do |t|
      t.string :name, :limit => 100
      t.string :email, :limit => 100
      t.text :bio

      t.timestamps
    end
    create_table :presenters_sessions, :id => false do |t|
      t.references :presenter, :session
    end
    add_index :presenters_sessions, [:presenter_id, :session_id]
  end
end
