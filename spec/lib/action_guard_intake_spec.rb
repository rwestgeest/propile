require 'spec_helper'

RSpec::Matchers.define :authorize do |account| 
  chain :to_perform_action do |action|
    @action = a_request_for(action)
  end
  match do |actual_guard| 
    actual_guard.authorized?(account, @action)
  end
end


describe ActionGuard do
  def a_request_for(path)
    request_params_for(path)
  end

  def request_params_for(path)
    path, parameters = path.split("?")
    controller, action = path.split('#')
    parameters_hash = Hash[ parameters &&  parameters.split("&").map {|key_value| key_value.split('=').map{|e| e.strip }} || [] ]
    parameters_hash['controller'] = controller
    parameters_hash['action'] = action || 'index'
    parameters_hash
  end
  let(:session) { FactoryGirl.create :session_with_presenter }
  let(:me) { FactoryGirl.create :presenter  }
  let(:my_account) { me.account }
  it "should authorize session index" do
    ActionGuard.should authorize(my_account).to_perform_action("sessions")
  end
  it "should not authorize session edit when session is not mine" do
    ActionGuard.should_not authorize(my_account).to_perform_action("sessions#edit?id=#{session.id}")
  end
  it "should authorize session edit when session is mine" do
    session.update_attribute :first_presenter_email, me.email
    ActionGuard.should authorize(my_account).to_perform_action("sessions#edit?id=#{session.id}")
  end

end
