class CommentsController < ApplicationController
  def index
    @comments = Comment.all
  end

  def show
    @comment = Comment.find(params[:id])
    @session = @comment.review.session
  end

  def new
    @review  = Review.find(params[:review_id])
    @session = @review.session
    @comment =  @review.comments.build()
    @comment.presenter = current_presenter
  end

  def edit
    @edit_comment = Comment.find(params[:id])
    @session = @edit_comment.review.session
    render template: 'sessions/show'
  end

  def create
    @new_comment = Comment.new(params[:comment])
    @new_comment.presenter = current_presenter
    @session = @new_comment.review.session
    @current_presenter_has_voted_for_this_session = Vote.presenter_has_voted_for?(current_presenter.id, @new_comment.review.session.id) 
    @my_vote = Vote.vote_of_presenter_for(current_presenter.id, @new_comment.review.session.id) 

    if params[:commit] != 'Preview' && @new_comment.save
      Postman.notify_comment_creation(@new_comment)
      redirect_to @new_comment.review.session, notice: 'Comment was successfully created.'
    else
      render template: 'sessions/show'
    end
  end

  def update
    @edit_comment = Comment.find(params[:id])
    @session = @edit_comment.review.session
    @current_presenter_has_voted_for_this_session = Vote.presenter_has_voted_for?(current_presenter.id, @edit_comment.review.session.id) 
    @my_vote = Vote.vote_of_presenter_for(current_presenter.id, @edit_comment.review.session.id) 

    if params[:commit] == 'Preview' 
      @edit_comment.assign_attributes(params[:comment])
      render template: 'sessions/show'
    else 
      if @edit_comment.update_attributes(params[:comment])
        redirect_to @edit_comment.review.session, notice: 'Comment was successfully created.'
      else
        render template: 'sessions/show'
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    redirect_to comments_url
  end
end
