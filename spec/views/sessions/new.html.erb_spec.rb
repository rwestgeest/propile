require 'spec_helper'

describe "sessions/new" do
  before(:each) do
    assign(:session, stub_model(Session).as_new_record)
  end

  it "renders new session form" do
    render

    assert_select "form", :action => sessions_path, :method => "post" do
    end
  end
end
