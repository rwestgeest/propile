class PresentersController < ApplicationController
  def index
    @presenters = Presenter.all
  end

  def show
    @presenter = Presenter.find(params[:id])
    @you_are_current_user = (current_presenter == @presenter)
  end

  def new
    @presenter = Presenter.new
  end

  def edit
    @presenter = Presenter.find(params[:id])
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
end
