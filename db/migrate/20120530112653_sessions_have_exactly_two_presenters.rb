class SessionsHaveExactlyTwoPresenters < ActiveRecord::Migration
  class Session < ActiveRecord::Base
    has_and_belongs_to_many :presenters
    belongs_to :first_presenter, :class_name => 'Presenter'
    belongs_to :second_presenter, :class_name => 'Presenter'
  end
  def up
    add_column :sessions, :first_presenter_id , :integer
    add_column :sessions, :second_presenter_id, :integer
    Session.reset_column_information
    Session.all.each do |session|
      session.update_attribute :first_presenter_id, session.presenters[0].id if session.presenters[0]
      session.update_attribute :second_presenter_id, session.presenters[1].id if session.presenters[1]
    end 
    add_index :sessions, :first_presenter_id
    add_index :sessions, :second_presenter_id
    drop_table :presenters_sessions
  end

  def down
    create_table :presenters_sessions, :id => false do |t|
      t.references :presenter, :session
    end

    add_index :presenters_sessions, [:presenter_id, :session_id]

    Session.reset_column_information

    Session.all.each do |session|
      session.presenters << session.first_presenter if session.first_presenter
      session.presenters << session.second_presenter if session.second_presenter
    end

    remove_column :sessions, :first_presenter_id
    remove_column :sessions, :second_presenter_id
  end
end
