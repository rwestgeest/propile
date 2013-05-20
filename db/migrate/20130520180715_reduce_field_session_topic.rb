class ReduceFieldSessionTopic < ActiveRecord::Migration
  class Session < ActiveRecord::Base
    attr_accessible :topic
  end
  def topic_class(topic)
    return "other" if topic.nil?
    topic_downcase = topic.downcase
    topic_class = case
      when topic_downcase.include?("techn")  then "technology"
      when topic_downcase.include?("customer") || topic_downcase.include?("planning")  then "customer"
      when topic_downcase.include?("case") || topic_downcase.include?("intro")  then "cases"
      when topic_downcase.include?("team") || topic_downcase.include?("individual")  then "team"
      when topic_downcase.include?("process") || topic_downcase.include?("improv")  then "process"
      else "other"
    end
  end

  def up
    Session.all.each do |session|
      session.update_attribute :topic, topic_class(session.topic)
    end
  end

  def down
    #not possible, not important
  end
end
