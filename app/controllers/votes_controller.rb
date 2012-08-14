class VotesController < ApplicationController
  def index
    @votes = Vote.all
  end

  def show
    @vote = Vote.find(params[:id])
  end

  def new
    @session = Session.find(params[:session_id])
    @vote =  @session.votes.build()
    @vote.presenter = current_presenter
  end

  def edit
    @vote = Vote.find(params[:id])
  end

  def create
    @vote = Vote.new(params[:vote])
    @vote.presenter = current_presenter

    if @vote.save
      redirect_to @vote, notice: 'Vote was successfully created.'
    else
      @session = @vote.session
      render action: "new"
    end
  end

  def update
    @vote = Vote.find(params[:id])

    if @vote.update_attributes(params[:vote])
      redirect_to @vote, notice: 'Vote was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy

    redirect_to votes_url
  end
end
