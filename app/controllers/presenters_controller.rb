class PresentersController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    if sort_column=="name"
      @presenters = Presenter.all.sort_by { |p| p.name.upcase }  
      @presenters = sort_direction=="asc" ? @presenters :  @presenters.reverse 
    elsif sort_column=="email"
      @presenters = Presenter.all.sort_by { |p| p.email.upcase }  
      @presenters = sort_direction=="asc" ? @presenters :  @presenters.reverse 
    else
      @presenters = Presenter.order( "upper("+sort_column+") " + sort_direction)
    end
  end

  def show
    @presenter = Presenter.find(params[:id])
    @you_are_current_user = (current_presenter == @presenter)
    @sessions_reviewed_by_you = (@presenter.reviews.all.collect { |r|  Session.find(r.session_id) } )
  end

  def new
    @presenter = Presenter.new
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

    if @presenter.save
      redirect_to @presenter, notice: 'Presenter was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @presenter = Presenter.find(params[:id])

    if @presenter.update_attributes(params[:presenter])
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

end
