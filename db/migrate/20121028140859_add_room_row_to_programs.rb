class AddRoomRowToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :room_row, :int
  end
end
