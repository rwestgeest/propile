class ReviewsController < ApplicationController
  def index
    @reviews = Review.all
  end

  def show
    @review = Review.find(params[:id])
  end

  def new
    @session = Session.find(params[:session_id])
    @review =  @session.reviews.build()
  end

  def edit
    @review = Review.find(params[:id])
  end

  def create
    @review = Review.new(params[:review])
    @review.presenter = current_presenter
    if @review.save
      Postman.notify_review_creation(@review)
      redirect_to @review, notice: 'Review was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @review = Review.find(params[:id])

    if @review.update_attributes(params[:review])
      redirect_to @review, notice: 'Review was successfully updated.'
    else
      render action: "edit"
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy

    redirect_to reviews_url
  end
end
