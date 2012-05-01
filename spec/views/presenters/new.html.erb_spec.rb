require 'spec_helper'

describe "presenters/new" do
  before(:each) do
    assign(:presenter, stub_model(Presenter).as_new_record)
  end

  it "renders new presenter form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => presenters_path, :method => "post" do
    end
  end
end
