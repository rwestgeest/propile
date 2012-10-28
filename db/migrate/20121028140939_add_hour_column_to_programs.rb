class AddHourColumnToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :hour_column, :integer
  end
end
