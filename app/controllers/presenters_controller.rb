class PresentersController < ApplicationController
  skip_before_filter :authorize_action, :only => [:export]
  helper_method :sort_column, :sort_direction

  def index
    if sort_column=="name"
      @presenters = Presenter.all.sort_by { |p| p.name.upcase }  
      @presenters = sort_direction=="asc" ? @presenters :  @presenters.reverse 
    elsif sort_column=="email"
      @presenters = Presenter.all.sort_by { |p| p.email.upcase }  
      @presenters = sort_direction=="asc" ? @presenters :  @presenters.reverse 
    else
      sort = begin
        if ( Presenter.attribute_names - %w[created_at] ).include?( sort_column.to_s )
          "upper(cast (#{sort_column} as text))"
        else
          'created_at'
        end
      end

      @presenters = Presenter.order( "#{sort} #{sort_direction}" )
    end
  end

  def show
    @presenter = Presenter.find(params[:id])
    @you_are_current_user = (current_presenter == @presenter)
    @sessions_reviewed_by_you = @presenter.sessions_reviewed
    @previous_login_time = previous_login_time
  end

  def dashboard
    @presenter = current_presenter
    @sessions_you_are_involved_in = @presenter.sessions_involved
    @sessions_that_need_a_review = Session.sessions_that_need_a_review
    @previous_login_time = previous_login_time
  end

  def new
    @presenter = Presenter.new
    respond_to do |format|
      format.html #new.html.erb
      format.json {render json: @product }
      format.js
    end
  end

  def edit
    @presenter = Presenter.find(params[:id])
  end

  def toggle_maintainer_role
    @presenter = Presenter.find(params[:id])
    @presenter.account.maintainer= !@presenter.account.maintainer? 
    @presenter.account.save!
    redirect_to @presenter, notice: 'Presenter was successfully updated.'
  end

  def create
    @presenter = Presenter.new(params[:presenter])

    respond_to do |format|
      if @presenter.save
        format.html {redirect_to :back, notice: 'Presenter was successfully created.'}
        format.json {render json: @product }
        format.js
      else
        format.html { render action: "new" }
        format.json {render json: @product }
        format.js
      end
    end
  end

  def update
    @presenter = Presenter.find(params[:id])
    if @presenter.update_attributes(params[:presenter]) 
      if current_account.maintainer? 
        @presenter.account.email = params[:presenter][:email] if params[:presenter][:email]
        @presenter.account.role = params[:presenter][:role] if  params[:presenter][:role]
        @presenter.account.save!(:validate => false)
      end
      redirect_to @presenter, notice: 'Presenter was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @presenter = Presenter.find(params[:id])
    @presenter.destroy

    redirect_to presenters_url
  end

  def sort_column
    params[:sort] ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end


  def export
    account = nil
    authenticate_with_http_basic do |username,password|
      account = Account.authenticate_by_email_and_password(username,password)
    end
    if account.nil? then
      request_http_basic_authentication("Propile presenter export")
    else
      @presenters = Presenter.all
      render :layout => false , :content_type => 'text/plain'  # just the html, mam
    end
  end


end
