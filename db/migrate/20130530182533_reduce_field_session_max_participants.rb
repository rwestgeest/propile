class ReduceFieldSessionMaxParticipants < ActiveRecord::Migration
  class Session < ActiveRecord::Base
    attr_accessible :max_participants
  end
  def up
    Session.all.each do |session|
      if session.max_participants
        reduced_max_participants= "#{session.max_participants.scan(/\d+/).first}" 
        session.update_attribute :max_participants, reduced_max_participants
      end
    end
  end

  def down
    #not possible, not important
  end
end
