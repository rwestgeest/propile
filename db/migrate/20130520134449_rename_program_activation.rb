class RenameProgramActivation < ActiveRecord::Migration
  def change
    rename_column :programs, :activation, :exported_at
  end
end
