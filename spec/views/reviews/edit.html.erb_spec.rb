require 'spec_helper'

describe "reviews/edit" do
  before(:each) do
    @review = assign(:review, FactoryGirl.create(:review))
  end

  it "renders the edit review form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => reviews_path(@review), :method => "post" do
    end
  end
end
