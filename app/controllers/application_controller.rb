class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_account

  protected
  def sign_in(account)
    session[:current_account_id] = account
  end
  def sign_out
    session[:current_account_id] = nil
  end
  def current_account
    @current_account ||= Account.find(current_account_id)
  end
  def current_presenter
    current_account.presenter
  end
  def current_account_id
    session[:current_account_id]
  end
end
