require 'spec_helper'
require 'menu'
describe Menu do
  include Menu
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::OutputSafetyHelper

  def link_to(name, url_options, html_options = {})
    raw "link_to(#{name}, #{url_options.inspect}, #{html_options.inspect})"
  end

  let(:menu) { Menu.create self }

  def normal_tab(link_name = 'LinkName', controller_path='controller_path') 
    "<li>#{link_to(link_name, request_params_for(controller_path))}</li>"
  end
  def highlighted_tab(link_name = 'LinkName', controller_path='controller_path') 
    "<li>#{link_to(link_name, request_params_for(controller_path), :class => 'active')}</li>"
  end

  before do
    ActionGuard.stub(:authorized?).and_return true
  end

  describe "render a menu tab" do
    it "renders menu link" do
      menu.tab("LinkName", 'controller_path').render(request_params_for('home')).should == normal_tab
    end

    it "authorizes the controller action" do
      ActionGuard.should_receive(:authorized?).with("some_account", request_params_for("controller_path"))
      menu.tab("LinkName", 'controller_path').render(request_params_for('home'), "some_account")
    end

    it "renders nothing when not authorized" do
      ActionGuard.stub(:authorized?).and_return false
      menu.tab("LinkName", 'controller_path').render(request_params_for('home'), "some_account").should == ''
    end

    it "renders more links" do
      menu.tab("Home", 'home')
      menu.tab("Admin", "admin")
      menu.render(request_params_for('blah')).should == [normal_tab('Home', 'home'), normal_tab('Admin', 'admin')].join("\n")
    end

  end

  describe "highlighting" do

    before do
      menu.tab("home", 'home')
    end

    it "renders highlighted menu tab for current path" do
      menu.render(request_params_for('home')).should == highlighted_tab('home', 'home')
    end

    it "renders highlighted menu tab if tabs path is parth of the current path" do
      menu.render(request_params_for('home#contact')).should == highlighted_tab('home', 'home')
    end

    it "renders hightight path can be overridden with highlight option" do
      menu.tab("contact", "contact#address", :highlight_on => 'contact')
      menu.render(request_params_for('contact#route')).should == [ normal_tab('home', 'home'), highlighted_tab('contact', 'contact#address')].join("\n")
      menu.render(request_params_for('contact/routes#index')).should == [ normal_tab('home', 'home'), highlighted_tab('contact', 'contact#address')].join("\n")
    end

    it "renders no highlighted menu if match is not from beginning" do
      menu.tab("about", 'home#about')
      menu.render(request_params_for('some/home#about')).should ==  [ normal_tab('home', 'home'), 
                                                  normal_tab('about', 'home#about')].join("\n")
    end

    it "renders prefers the longest path to select" do
      menu.tab("about", 'home#about')
      menu.render(request_params_for('home#about')).should ==  [ normal_tab('home', 'home'), 
                                              highlighted_tab('about', 'home#about')].join("\n")
    end

    it "renders prefers the longest path to select regardless of order" do
      menu.tab("users", 'admin#users')
      menu.tab("admin", 'admin')
      menu.render(request_params_for('admin#users')).should == [ normal_tab('home', 'home'), 
                                              highlighted_tab('users', 'admin#users'), 
                                              normal_tab('admin', 'admin')].join("\n")
    end

  end
end
