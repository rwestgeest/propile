class ReviewsController < ApplicationController
  def index
    @reviews = Review.all
  end

  def make_parameters_for_show_session(review)
    @session = review.session
    @current_presenter_has_voted_for_this_session = Vote.presenter_has_voted_for?(current_presenter.id, review.session.id) 
    @my_vote = Vote.vote_of_presenter_for(current_presenter.id, review.session.id) 
  end

  def show
    make_parameters_for_show_session(Review.find(params[:id]))
    render template: 'sessions/show'
  end

  def new
    @session = Session.find(params[:session_id])
    @review =  @session.reviews.build()
    @review.presenter = current_presenter
  end

  def edit
    @edit_review = Review.find(params[:id])
    make_parameters_for_show_session(@edit_review)
    render template: 'sessions/show'
  end

  def create
    @new_review = Review.new(params[:review])
    @new_review.presenter = current_presenter
    make_parameters_for_show_session(@new_review)

    if params[:commit] != 'Preview' && @new_review.save
      Postman.notify_review_creation(@new_review)
      redirect_to @new_review.session, notice: 'Review was successfully created.'
    else
      @anchor="session_review_new"
      render template: "sessions/show"
    end
  end

  def update
    @edit_review = Review.find(params[:id])
    make_parameters_for_show_session(@edit_review)
    if params[:commit] == 'Preview' 
      @edit_review.assign_attributes(params[:review])
      render template: 'sessions/show'
    else 
      if @edit_review.update_attributes(params[:review])
        redirect_to @edit_review.session, notice: 'Review was successfully created.'
      else
        render template: 'sessions/show'
      end
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy

    redirect_to reviews_url
  end
end
