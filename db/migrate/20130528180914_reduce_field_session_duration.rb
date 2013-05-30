class ReduceFieldSessionDuration < ActiveRecord::Migration
  class Session < ActiveRecord::Base
    AVAILABLE_DURATION = [ "60 min", "90 min", "120 min", "180 min" ]
    attr_accessible :duration
  end
  def up
    Session.all.each do |session|
      if session.duration
        reduced_duration = "#{session.duration.scan(/\d+/).first} min" 
        if !Session::AVAILABLE_DURATION.include? reduced_duration
          case  
          when reduced_duration < "60 min" 
            reduced_duration = "60 min"
          when reduced_duration == "150 min" 
            reduced_duration  = "120 min"
          end
        end
        session.update_attribute :duration, reduced_duration
      end
    end
  end

  def down
    #not possible, not important
  end
end
