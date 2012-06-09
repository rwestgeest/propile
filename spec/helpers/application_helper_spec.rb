require 'spec_helper'

describe ApplicationHelper do
  include ApplicationHelper

  def current_account
    'some_account'
  end

  def link_to(what, url_options)
    "link to #{what} with #{url_options.inspect}"
  end

  describe "guarded_link_to" do

    let(:link_params) {{:controller => 'some_controller', :action => 'some_action'}} 
    it "authorizes action with action guard" do
      ActionGuard.should_receive(:authorized?).with(current_account, link_params.stringify_keys)
      guarded_link_to 'link_text', link_params
    end
    it "renders the link if authorized" do
      ActionGuard.should_receive(:authorized?).and_return true
      guarded_link_to('link_text', link_params).should == link_to('link_text', link_params)
    end
    it "renders nothing if not authorized" do
      ActionGuard.should_receive(:authorized?).and_return false
      guarded_link_to('link_text', link_params).should == ''
    end
  
  end

  describe "wikinized", :focus => true do
    it "nil returns empty string" , :focus => true do
       wikinized(nil).should == ""
    end

    it "empty string returns empty string" , :focus => true do
       wikinized("").should == ""
    end

    it "simple string is wrapped in <p>" , :focus => true do
       wikinized("simple string").should == "<p>simple string</p>"
    end

    it "new-line returns <br/>" , :focus => true do
       wikinized("string\nwith newline").should == "<p>string\n<br />with newline</p>"
    end

    it "2 new-lines return new <p>" , :focus => true do
       wikinized("string\n\nwith newline").should == "<p>string</p>\n\n<p>with newline</p>"
    end

    it "bold" , :focus => true do
       wikinized("simple string with *bold* word").should == "<p>simple string with <b>bold</b> word</p>"
    end

    it "bold not closed returns *" , :focus => true do
       wikinized("simple string with *bold-not-closed word").should == "<p>simple string with *bold-not-closed word</p>"
    end

    it "italic" , :focus => true do
       wikinized("simple string with _italic_ word").should == "<p>simple string with <i>italic</i> word</p>"
    end
  end
end
