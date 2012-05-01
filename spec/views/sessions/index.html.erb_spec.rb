require 'spec_helper'

describe "sessions/index" do
  before(:each) do
    assign(:sessions, [
      FactoryGirl.create(:session),
      FactoryGirl.create(:session)
    ])
  end

  it "renders a list of sessions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
