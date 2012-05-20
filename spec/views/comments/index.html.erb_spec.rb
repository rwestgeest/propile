require 'spec_helper'

describe "comments/index" do
  before(:each) do
    assign(:comments, [
      FactoryGirl.create(:comment),
      FactoryGirl.create(:comment)
    ])
  end

  it "renders a list of comments" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
