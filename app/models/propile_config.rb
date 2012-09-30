class PropileConfig < ActiveRecord::Base
  attr_accessible :description, :name, :value

  def self.is_set (prop_name)
    prop = find_by_name(prop_name) 
    !prop.nil? && prop.value == "true" 
  end

  def self.set(prop_name, prop_value)
    prop = find_by_name(prop_name) 
    if prop.nil? 
      PropileConfig.new(:name=>prop_name, :value=>prop_value).save
    else
      prop.value = prop_value 
      prop.save 
    end
  end

  def self.submit_session_active?
    is_set( "submit_session_active" )
  end

  def self.submit_session_active=(prop_value)
    set( "submit_session_active", prop_value )
  end

  def self.voting_active?
    is_set( "voting_active" )
  end

  def self.voting_active=(prop_value)
    set( "voting_active", prop_value )
  end

end
