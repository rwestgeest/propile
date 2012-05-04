require 'spec_helper'

describe "sessions/index" do
  before(:each) do
    assign(:sessions, [
      FactoryGirl.create(:session_with_presenter),
      FactoryGirl.create(:session_with_presenter)
    ])
  end

  it "renders a list of sessions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
