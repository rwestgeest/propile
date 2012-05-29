class Account::PasswordResetsController < PublicController
  layout 'sessions'
  def new
    @account = Account.new
  end
  def create
    @account = Account.find_by_email( params[:account][:email] )
    if (@account) 
      @account.reset!
      redirect_to success_account_password_reset_path
    else
      flash.alert = 'This e-mail address is not known to us' 
      @account = Account.new
      render :action => :new
    end
  end
  def success

  end
end
