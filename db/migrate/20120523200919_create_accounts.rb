class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :login, :limit => 150, :null => false
      t.string :role, :limit => 50, :null => false, :default => 'submitter'
      t.string :encrypted_password
      t.string :password_salt
      t.string :authentication_token
      t.datetime :confirmed_at
      t.references :person

      t.timestamps
    end
    add_index :accounts, :person_id
  end
end
