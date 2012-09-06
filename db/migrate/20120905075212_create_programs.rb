class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.string :version

      t.timestamps
    end
  end
end
