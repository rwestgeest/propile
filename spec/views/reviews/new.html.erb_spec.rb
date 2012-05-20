require 'spec_helper'

describe "reviews/new" do
  before(:each) do
    assign(:review, stub_model(Review).as_new_record)
  end

  it "renders new review form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => reviews_path, :method => "post" do
    end
  end
end
