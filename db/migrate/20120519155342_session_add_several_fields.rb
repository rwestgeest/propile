class SessionAddSeveralFields < ActiveRecord::Migration
  def change
    add_column :sessions, :sub_title, :string
    add_column :sessions, :short_description, :string
    add_column :sessions, :session_type, :string
    add_column :sessions, :topic, :string
    add_column :sessions, :duration, :string
    add_column :sessions, :intended_audience, :string
    add_column :sessions, :experience_level, :string
    add_column :sessions, :max_participants, :string
    add_column :sessions, :laptops_required, :string
    add_column :sessions, :other_limitations, :string
    add_column :sessions, :room_setup, :string
    add_column :sessions, :materials_needed, :string
    add_column :sessions, :session_goal, :string
    add_column :sessions, :outline_or_timetable, :string
  end
end
