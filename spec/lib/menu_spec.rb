require 'spec_helper'
require 'menu'

describe Menu do
  include ActionView::Helpers::UrlHelper
  let(:menu) { Menu.new() }

  def normal_tab(link_name = 'LinkName', link_path='/link_path') 
    "<li>#{link_to(link_name, link_path)}</li>"
  end
  def highlighted_tab(link_name = 'LinkName', link_path='/link_path') 
    "<li>#{link_to(link_name, link_path, :class => :active)}</li>"
  end

  before do
    ActionGuard.stub!(:authorized?).and_return true
  end

  describe "render a menu tab" do
    it "renders menu link" do
      menu.tab("LinkName", '/link_path').render('/').should == normal_tab
    end

    it "renders nothing when not authorized" do
      ActionGuard.stub!(:authorized?).with("some_account", '/link_path').and_return false
      menu.tab("LinkName", '/link_path').render('/', "some_account").should == ''
    end

    it "renders more links" do
      menu.tab("Home", '/home')
      menu.tab("Admin", "/admin")
      menu.render('/').should == [normal_tab('Home', '/home'), normal_tab('Admin', '/admin')].join("\n")
    end

  end

  describe "highlighting" do

    before do
      menu.tab("home", '/home')
    end

    it "renders highlighted menu tab for current path" do
      menu.render('/home').should == highlighted_tab('home', '/home')
    end

    it "renders highlighted menu tab if tabs path is parth of the current path" do
      menu.render('/home/contact').should == highlighted_tab('home', '/home')
    end

    it "renders hightight path can be overridden with highlight option" do
      menu.tab("contact", "/contact/address", :highlight_on => '/contact')
      menu.render('/contact/route').should == [ normal_tab('home', '/home'), highlighted_tab('contact', '/contact/address')].join("\n")
    end

    it "renders no highlighted menu if match is not from beginning" do
      menu.tab("about", '/home/about')
      menu.render('/some/home/about').should ==  [ normal_tab('home', '/home'), 
                                                   normal_tab('about', '/home/about')].join("\n")
    end

    it "renders prefers the longest path to select" do
      menu.tab("about", '/home/about')
      menu.render('/home/about').should ==  [ normal_tab('home', '/home'), 
                                              highlighted_tab('about', '/home/about')].join("\n")
    end

    it "renders prefers the longest path to select regardless of order" do
      menu.tab("users", '/admin/users')
      menu.tab("admin", '/admin')
      menu.render('/admin/users').should == [ normal_tab('home', '/home'), 
                                              highlighted_tab('users', '/admin/users'), 
                                              normal_tab('admin', '/admin')].join("\n")
    end

  end
end
