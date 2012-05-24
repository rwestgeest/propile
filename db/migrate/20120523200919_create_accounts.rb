class CreateAccounts < ActiveRecord::Migration
  class Account < ActiveRecord::Base
    attr_accessible :email, :authentication_token
  end
  class Presenter < ActiveRecord::Base
    attr_accessible :email, :login_guid 
  end
  def self.up
    create_table :accounts do |t|
      t.string :email, :limit => 150, :null => false
      t.string :role, :limit => 50, :null => false, :default => 'presenter'
      t.string :encrypted_password
      t.string :password_salt
      t.string :authentication_token
      t.datetime :confirmed_at
      t.datetime :reset_at
      t.timestamps
    end
    add_index :accounts, :email
    add_index :accounts, :authentication_token
    add_column :presenters, :account_id, :integer

    Account.reset_column_information
    Presenter.reset_column_information

    Presenter.all.each do |p| 
      a = Account.create!( email: p.email, authentication_token: p.login_guid) 
      p.update_attribute :account_id, a.id
    end

    remove_column :presenters, :login_guid
    remove_column :presenters, :email
    add_index :presenters, :account_id
  end

  def self.down 
    add_column :presenters, :login_guid, :string
    add_column :presenters, :email, :string

    Presenter.reset_column_information
    Presenter.all.each do |p| 
      a = Account.find(p.account_id)
      p.update_attributes email: a.email, login_guid: a.authentication_token
    end

    remove_column :presenters, :account_id
    drop_table :accounts
  end
end
