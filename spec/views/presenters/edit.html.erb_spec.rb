require 'spec_helper'

describe "presenters/edit" do
  before(:each) do
    @presenter = assign(:presenter, stub_model(Presenter))
  end

  it "renders the edit presenter form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => presenters_path(@presenter), :method => "post" do
    end
  end
end
