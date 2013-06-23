class AddLastloginToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :last_login, :timestamp
  end
end
