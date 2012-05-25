class Account::SessionsController < ApplicationController
  layout 'sessions'
  def new
    @account = Account.new
  end

  def create
    @account = Account.authenticate_by_email_and_password(account_params[:email], account_params[:password])
    if @account 
      sign_in @account
      redirect_to @account.landing_page
    else
      flash.alert = 'e-mail or password incorrect' 
      @account = Account.new
      render :action => 'new'
    end
  end

  def destroy
    sign_out
    redirect_to new_account_session_path
  end
  private 

  def account_params
    @account_params ||= params[:account]
  end
end
