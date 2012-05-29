class ApplicationController < ActionController::Base
  protect_from_forgery
  prepend_before_filter :authorize_action
  helper_method :current_account
  helper_method :signed_in?

  def signed_in?
    not session[:current_account_id].nil?
  end

  protected
  def authorized?(fullpath)
    ActionGuard.authorized?(current_account, fullpath)
  end
  helper_method :authorized?

  private

  def authorize_action
    # unless current_account
    #   redirect_to new_account_session_path
    #   return
    # end
    unless authorized?(request.fullpath)
      flash[:alert] = I18n.t("not_authorized")
      sign_out 
      redirect_to new_account_session_path
    end
  end
  def sign_in(account)
    session[:current_account_id] = account
  end
  def sign_out
    session[:current_account_id] = nil
  end
  def current_account
    @current_account ||= Account.find(current_account_id) rescue nil
  end
  def current_presenter
    current_account.presenter
  end
  def current_account_id
    session[:current_account_id]
  end
end
