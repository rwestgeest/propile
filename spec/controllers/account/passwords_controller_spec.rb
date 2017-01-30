require 'spec_helper'

describe Account::PasswordsController do
  it_should_behave_like "a guarded resource controller", :presenter, :maintainer, 
    :except => [:new, :create, :show, :index, :destroy]

  context "when logged in" do
    render_views
    login_as :presenter

    def valid_parameters
      {:password => 'secret', :password_confirmation => 'secret' }
    end

    describe "GET 'edit'" do
      it "returns http success" do
        get 'edit'
        response.should be_success
        response.body.should have_selector("form[action='#{account_password_path}']") do |form|
          form.should have_selector['input@account_password']
          form.should have_selector['input@account_password_confirmation']
        end
      end
    end
    describe "PUT 'update'" do
      context "with valid params" do
        def update 
          put 'update', :account => valid_parameters
        end
        it "redirects to the accounts langding page" do
          update
          response.should redirect_to(current_account.landing_page)
        end
        it "updates the password" do
          update
          current_account.authenticate('secret').should == true
        end
        it "confirms the account" do
          update
          current_account.should be_confirmed
        end
        it "removes the reset state if needed" do
          current_account.confirm_with_password valid_parameters
          current_account.reset!
          update
          current_account.reload
          current_account.should_not be_reset
        end
      end
      context "with invalid params" do
        before {
          put 'update', :account => valid_parameters.merge(:password_confirmation => 'terces')
        }
        it "renders the edit form again" do
          response.should render_template :edit
        end
      end
    end
  end
end
