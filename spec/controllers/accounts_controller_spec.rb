require 'spec_helper'

describe AccountsController do
  render_views

  def valid_attributes
    FactoryGirl.attributes_for :account
  end

  def create_confirmed_account
    FactoryGirl.create :confirmed_account
  end

  let(:account) { create_confirmed_account }

  context "when logged in" do
    login_as :maintainer
    describe "GET index" do
      let!(:account) { create_confirmed_account }
      it "assigns all accounts as @accounts" do
        get :index, {}
        assigns(:accounts).should include(account)
      end
    end

    describe "GET show" do
      it "assigns the requested account as @account" do
        get :show, {:id => account.to_param}
        assigns(:account).should eq(account)
      end
    end

  describe "GET new" do
    it "assigns a new account as @account" do
      get :new, {}
      assigns(:account).should be_a_new(Account)
    end
  end

    describe "GET edit" do
      it "assigns the requested account as @account" do
        get :edit, {:id => account.to_param}
        assigns(:account).should eq(account)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Account" do
          expect {
            post :create, {:account => valid_attributes}
          }.to change(Account, :count).by(1)
        end

        it "assigns a newly created account as @account" do
          post :create, {:account => valid_attributes}
          assigns(:account).should be_a(Account)
          assigns(:account).should be_persisted
        end

        it "redirects to the created account" do
          post :create, {:account => valid_attributes}
          response.should redirect_to(Account.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved account as @account" do
          # Trigger the behavior that occurs when invalid params are submitted
          Account.any_instance.stub(:save).and_return(false)
          post :create, {:account => {}}
          assigns(:account).should be_a_new(Account)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Account.any_instance.stub(:save).and_return(false)
          post :create, {:account => {}}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      let!(:account) { create_confirmed_account }
      describe "with valid params" do
        it "updates the requested account" do
          # Assuming there are no other accounts in the database, this
          # specifies that the Account created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Account.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, {:id => account.to_param, :account => {'these' => 'params'}}
        end

        it "assigns the requested account as @account" do
          put :update, {:id => account.to_param, :account => valid_attributes}
          assigns(:account).should eq(account)
        end

        it "redirects to the account" do
          put :update, {:id => account.to_param, :account => valid_attributes}
          response.should redirect_to(account)
        end
      end

      describe "with invalid params" do
        it "assigns the account as @account" do
          # Trigger the behavior that occurs when invalid params are submitted
          Account.any_instance.stub(:save).and_return(false)
          put :update, {:id => account.to_param, :account => {}}
          assigns(:account).should eq(account)
        end

        it "re-renders the 'edit' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Account.any_instance.stub(:save).and_return(false)
          put :update, {:id => account.to_param, :account => {}}
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      let!(:account) { create_confirmed_account }
      it "destroys the requested account" do
        expect {
          delete :destroy, {:id => account.to_param}
        }.to change(Account, :count).by(-1)
      end

      it "redirects to the accounts list" do
        delete :destroy, {:id => account.to_param}
        response.should redirect_to(accounts_url)
      end
    end
  end

end
