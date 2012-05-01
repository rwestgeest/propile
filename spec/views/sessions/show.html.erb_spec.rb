require 'spec_helper'

describe "sessions/show" do
  before(:each) do
    @session = assign(:session, FactoryGirl.create(:session))
  end

  it "renders attributes in <p>" do
    render
    #rendered.should include "bla" 
  end
end
