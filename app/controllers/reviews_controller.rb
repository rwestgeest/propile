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
      redirect_to @review, notice: 'Review was successfully created.'
    else
      @session = @review.session
      render action: "new"
    end
  end

  def update

    if params[:commit] == 'Preview' 
      @review = Review.new(params[:review])
      @review.presenter = current_presenter
      @session = @review.session
      render action: "edit"
    else 
      @review = Review.find(params[:id])
      @session = @review.session
      if @review.update_attributes(params[:review])
        redirect_to @review, notice: 'Review was successfully updated.'
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
