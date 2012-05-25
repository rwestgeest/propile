class Account::ResponseSessionsController < ApplicationController
  layout 'sessions'
  def show
    @account = Account.find_by_authentication_token(params[:id])
    if @account
      sign_in @account
      redirect_to @account.landing_page
    else
      render status: :not_found
    end
  end

end
