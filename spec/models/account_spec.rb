require 'spec_helper'

describe Account do
  describe 'generate_authentication_token' do
    let!(:existing_account) { FactoryGirl.create :maintainer_account }
    let(:account) { Account.new }
    it "generates some random token" do
      TokenGenerator.stub(:generate_token => "first_generated_token")
      account.generate_authentication_token
      account.authentication_token.should == "first_generated_token"
    end
    it "makes sure it is unique" do
      TokenGenerator.stub(:generate_token).and_return(existing_account.authentication_token, existing_account.authentication_token, "first_free_generated_token")
      account.generate_authentication_token
      account.authentication_token.should == "first_free_generated_token"
    end
    def isGuid(s)
      (s =~ /^(\{){0,1}[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}(\}){0,1}$/) != nil
    end
    it "is a guid" do
      account.generate_authentication_token
      isGuid(account.authentication_token).should == true
    end
  end

  describe 'authenticate' do
    let!(:account) { FactoryGirl.create :maintainer_account } 

    describe 'on token'  do
      it "fails when token is nil" do
        account.update_attribute :authentication_token, nil
        Account.authenticate_by_token(nil).should be_nil 
      end
      it "fails when token is empty" do
        account.update_attribute :authentication_token, ''
        Account.authenticate_by_token('').should be_nil 
      end
      it "passes when token is present" do
        Account.authenticate_by_token(account.authentication_token).should == account
      end
    end
    describe 'on password' do
      before { account.confirm_with_password :password => 'secret', :password_confirmation => 'secret' }
      it "fails when password does not match" do
        Account.authenticate_by_email_and_password(account.email, 'xxxx').should be_nil
        Account.authenticate_by_email_and_password("other"+account.email, 'secret').should be_nil
      end
      it "passes when password matcher" do
        Account.authenticate_by_email_and_password(account.email, 'secret').should == account
      end
      it "fails when account is not confirmed" do
        account.update_attribute :confirmed_at, nil
        Account.authenticate_by_email_and_password(account.email, 'secret').should be_nil
      end
    end
  end

  describe 'change password' do
    attr_reader :account
    let(:old_password) { account.password }

    before do 
      @account = FactoryGirl.create(:presenter_account, :password => "secret", :password_confirmation => "secret")
      @account.confirm!
      @account = Account.find(@account.id)
    end

    it "updates password if password is passed and matches password_confirmation" do
      account.update_attributes(:password => 'secret', :password_confirmation => 'secret').should be_true
      account.password.should == 'secret'
    end

    it "ignores passwords if not passed " do
      account.update_attributes({})
      account.password.should == old_password
    end

    it "ingores passwords if nil" do
      account.update_attributes({:password => nil}).should be_true
      account.password.should == old_password
    end
  end


  describe 'reset!' do
    def reset_account
      account.reset!
      account.reload
    end

    context "on a confirmed account" do
      let!(:account) { FactoryGirl.create :confirmed_account }
      it "generates a new token" do
        old_token = account.authentication_token
        reset_account
        account.authentication_token.should_not == old_token
      end
      it "sets the account to reset" do
        reset_account
        account.should be_reset
      end
      it "sends an account reset mail" do
        Postman.should_receive(:deliver).with(:account_reset, account)
        account.reset!
      end
      it "sets the landing page to change password" do
        account.reset!
        account.landing_page.should == '/account/password/edit'
      end
    end

    context "on a new account" do
      let!(:account) { FactoryGirl.create :account }
      it "keeps the old token" do
        old_token = account.authentication_token
        reset_account
        account.authentication_token.should == old_token
      end
      it "sends an account reset mail" do
        Postman.should_receive(:deliver).with(:account_reset, account)
        account.reset!
      end
      it "leaves the reset state to false"  do
        reset_account
        account.should_not be_reset
      end
    end
  end

  shared_examples_for "a confirmable account" do
    it "is initially not confirmed" do
      account.should_not be_confirmed
    end

    it "has a change_password landing page" do
      account.landing_page.should == '/account/password/edit'
    end

    it "should have a confirmation token" do
      account.authentication_token.should_not be_empty
    end

    context "without_password" do
      it "fails" do
        account.confirm!.should be_false
        account.reload #reload the account from database by id
        account.should_not be_confirmed
      end
    end

    describe "with_password" do

      describe "with valid password" do 

        it "returns true and confirms" do
          confirmation_result = confirm_with_password!
          confirmation_result.should be_true
          account.should be_confirmed
        end

        it "makes it not reset" do
          confirm_with_password!
          account.reset!
          confirm_with_password!
          account.should_not be_reset
        end

        it "sets password" do
          confirmation_result = confirm_with_password!
          account.encrypted_password.should_not be_empty
        end

      end

      describe "with invalid password" do 
        it "returns false and does not confirm" do
          account.confirm_with_password(:password => '').should be_false
          account.should_not be_confirmed
        end
      end
    end
  end

  describe 'confirm' do 
    def confirm_with_password!
      account.confirm_with_password :password => 'secret', :password_confirmation => 'secret'
      account.reload
    end

    context "maintainer" do
      let(:account) { 
        FactoryGirl.create(:maintainer_account, 
                           :password => nil, 
                           :password_confirmation => nil)
      }

      it_should_behave_like "a confirmable account"
    end
    context "presenter" do
      let(:account) { 
        FactoryGirl.create(:presenter_account, 
                           :password => nil, 
                           :password_confirmation => nil)
      }

      it_should_behave_like "a confirmable account"
    end
  end

end
