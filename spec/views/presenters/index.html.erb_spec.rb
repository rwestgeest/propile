require 'spec_helper'

describe "presenters/index" do
  before(:each) do
    assign(:presenters, [
      stub_model(Presenter),
      stub_model(Presenter)
    ])
  end

  it "renders a list of presenters" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
