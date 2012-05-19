class Session < ActiveRecord::Migration
  def change
    add_column :session, :sub_title, :string
    add_column :session, :short_description, :string
    add_column :session, :session_type, :string
    add_column :session, :topic, :string
    add_column :session, :duration, :string
    add_column :session, :intended_audience, :string
    add_column :session, :experience_level, :string
    add_column :session, :max_participants, :string
    add_column :session, :laptops_required, :string
    add_column :session, :other_limitations, :string
    add_column :session, :room_setup, :string
    add_column :session, :materials_needed, :string
    add_column :session, :session_goal, :string
    add_column :session, :outline_or_timetable, :string
  end
end
