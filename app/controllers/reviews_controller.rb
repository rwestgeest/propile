class ReviewsController < ApplicationController
  def index
    @reviews = Review.all
  end

  def show
    @review = Review.find(params[:id])
    @session = @review.session
  end

  def new
    @session = Session.find(params[:session_id])
    @review =  @session.reviews.build()
    @review.presenter = current_presenter
  end

  def edit
    @review = Review.find(params[:id])
    @session = @review.session
  end

  def create
    @review = Review.new(params[:review])
    @review.presenter = current_presenter
    if params[:commit] != 'Preview' && @review.save
      Postman.notify_review_creation(@review)
      redirect_to @review.session, notice: 'Review was successfully created.'
    else
      @session = @review.session
      @current_presenter_has_voted_for_this_session = Vote.presenter_has_voted_for?(current_presenter.id, @review.session.id) 
      @my_vote = Vote.vote_of_presenter_for(current_presenter.id, @review.session.id) 
      @new_review=@review
      render template: "sessions/show"
    end
  end

  def update
    @review = Review.find(params[:id])
    @session = @review.session
    if params[:commit] == 'Preview' 
      @review.assign_attributes(params[:review])
      render action: "edit"
    else 
      if @review.update_attributes(params[:review])
        redirect_to @review.session, notice: 'Review was successfully created.'
      else
        render action: "edit"
      end
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy

    redirect_to reviews_url
  end
end
