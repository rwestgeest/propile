require 'spec_helper'

describe "reviews/index" do
  before(:each) do
    assign(:reviews, [
      FactoryGirl.create(:review),
      FactoryGirl.create(:review)
    ])
  end

  it "renders a list of reviews" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
