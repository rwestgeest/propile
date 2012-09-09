class AddCommentToProgramEntry < ActiveRecord::Migration
  def change
    add_column :program_entries, :comment, :string
  end
end
