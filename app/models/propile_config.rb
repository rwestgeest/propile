class PropileConfig < ActiveRecord::Base
  attr_accessible :description, :name, :value

  SUBMIT_SESSION_ACTIVE = "submit_session_active" 
  VOTING_ACTIVE = "voting_active" 

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

  def self.toggle(prop_name)
    set( prop_name, (!is_set(prop_name)).to_s )
  end

  def self.submit_session_active?
    is_set( SUBMIT_SESSION_ACTIVE )
  end

  def self.submit_session_active=(prop_value)
    set( SUBMIT_SESSION_ACTIVE, prop_value )
  end
  
  def self.voting_active?
    is_set( VOTING_ACTIVE )
  end

  def self.voting_active=(prop_value)
    set( VOTING_ACTIVE, prop_value )
  end

end
