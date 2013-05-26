class CreateArchivedPresenters < ActiveRecord::Migration
  def change

    create_table "archived_presenters", :force => true do |t|
      t.string   "name",       :limit => 100
      t.string   "email",      :limit => 150
      t.text     "bio"
      t.datetime "created_at",                :null => false
      t.datetime "updated_at",                :null => false
    end

    add_index "archived_presenters", ["email"], :name => "index_archived_presenters_on_email"
  end

end
