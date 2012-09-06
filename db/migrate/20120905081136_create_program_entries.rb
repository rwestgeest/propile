class CreateProgramEntries < ActiveRecord::Migration
  def change
    create_table :program_entries do |t|
      t.references :program
      t.integer :slot
      t.integer :track
      t.references :session

      t.timestamps
    end
    add_index :program_entries, :program_id
    add_index :program_entries, :session_id
  end
end
