class SessionsController < ApplicationController
  skip_before_filter :authorize_action, :only => [:new, :create, :thanks]
  def index
    @sessions = Session.all.sort { 
      |s1, s2| 
      size_compare = (s1.reviews.size <=> s2.reviews.size) 
      size_compare==0 ? (s1.created_at <=> s2.created_at) : size_compare
    } 
  end

  def show
    @session = Session.find(params[:id])
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
end
