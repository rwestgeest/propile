require 'spec_helper'

describe "presenters/show" do
  before(:each) do
    @presenter = assign(:presenter, stub_model(Presenter))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
