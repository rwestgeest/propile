class AddActivationDatetimeToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :activation, :datetime
  end
end
