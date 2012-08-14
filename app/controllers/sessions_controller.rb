class SessionsController < ApplicationController
  skip_before_filter :authorize_action, :only => [:new, :create, :thanks]
  helper_method :sort_column, :sort_direction

  def index
    if sort_column=="reviewcount"
      @sessions = Session.all.sort { 
        |s1, s2| 
        size_compare = (s1.reviews.size <=> s2.reviews.size) 
        size_compare==0 ? (s1.created_at <=> s2.created_at) : size_compare
      } 
      @sessions = sort_direction=="asc" ? @sessions :  @sessions.reverse 
    elsif sort_column=="presenters"
      @sessions = Session.all.sort_by { |s| s.presenter_names }  
      @sessions = sort_direction=="asc" ? @sessions :  @sessions.reverse 
    else
      @sessions = Session.order(sort_column + " " + sort_direction)
    end
  end

  def show
    @session = Session.find(params[:id])
    @current_presenter_has_voted_for_this_session = Vote.presenter_has_voted_for?(current_presenter.id, params[:id]) 
  end

  def new
    @session = Session.new
  end

  def edit
    @session = Session.find(params[:id])
  end

  def thanks
    @session = Session.find(params[:id])
  end

  def create
    @session = Session.new(params[:session])
    unless Captcha.verified?(self)
      flash[:alert]  = I18n.t('sessions.captcha_error')
      render :action => 'new'
      return
    end
    if @session.save
      redirect_to thanks_session_path(@session), notice: 'Session was successfully created.' 
      @session.presenters.each { |presenter| Postman.deliver(:session_submit, presenter, @session) }
    else
      render action: "new"
    end
  end

  def update
    @session = Session.find(params[:id])

    if @session.update_attributes(params[:session])
      redirect_to @session, notice: 'Session was successfully updated.' 
    else
      render action: "edit" 
    end
  end

  def destroy
    @session = Session.find(params[:id])
    @session.destroy

    redirect_to sessions_url 
  end

  def sort_column
    params[:sort] ? params[:sort] : "reviewcount"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end


end
