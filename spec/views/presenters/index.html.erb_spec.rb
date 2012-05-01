require 'spec_helper'

describe "presenters/index" do
  before(:each) do
    assign(:presenters, [
      FactoryGirl.create(:presenter),
      FactoryGirl.create(:presenter)
    ])
  end

  it "renders a list of presenters" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
