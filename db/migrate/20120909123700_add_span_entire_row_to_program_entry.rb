class AddSpanEntireRowToProgramEntry < ActiveRecord::Migration
  def change
    add_column :program_entries, :span_entire_row, :boolean
  end
end
