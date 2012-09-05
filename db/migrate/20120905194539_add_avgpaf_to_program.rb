class AddAvgpafToProgram < ActiveRecord::Migration
  def change
    add_column :programs, :avgpaf, :integer
  end
end
