require 'spec_helper'

describe Account::SessionsController do
  render_views
  let(:account) { FactoryGirl.create :confirmed_account  }
  def valid_attributes 
    { email: account.email, password: account.password }
  end

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
      response.body.should have_selector("form[action='#{account_session_path(assigns(:account))}']") do |form|
        form.should_have_selector('input#account_email')
        form.should_have_selector('input#account_password')
      end
    end
  end

  describe "POST 'create'" do
    context "with valid parameters" do
      it "redirect to the accounts landing page" do
        post 'create', :account => valid_attributes
        response.should redirect_to(account.landing_page)
      end
      it "logs in" do
        post 'create', :account => valid_attributes
        current_account.should == account
        @controller.send(:current_account).should == account
      end
    end
    context "with invalid parameters" do
      before {  post 'create', :account => valid_attributes.merge(password: 'false')  }
      it "renders the form again" do
        response.should be_success
        response.should render_template(:new)
      end
      it "sets the flash alert" do
        response.body.should have_selector("#alert")
      end
    end
  end

  describe "DELETE 'destroy'" do
    login_as :presenter
    it "signs out the current account" do
      delete 'destroy'
      current_account.should == nil
    end
    it "redirects to root" do
      delete 'destroy'
      response.should redirect_to(root_path)
    end
  end
end
