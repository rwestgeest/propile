class ProgramEntry < ActiveRecord::Base
  belongs_to :program
  belongs_to :session

  attr_accessible :slot, :track, :comment, :span_entire_row
  attr_accessible :session_id, :program_id
  
  def topic_class
    topic = session ? session.topic.downcase : ""
    topic_class = case  
      when topic.include?("techn")  then "technology"
      when topic.include?("customer") || topic.include?("planning")  then "customer"
      when topic.include?("case") || topic.include?("intro")  then "cases"
      when topic.include?("team") || topic.include?("individual")  then "team"
      when topic.include?("process") || topic.include?("improv")  then "process"
      else ""
    end
  end

end
