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
    @comment = Comment.find(params[:id])
    @session = @comment.review.session
    render template: 'sessions/show'
  end

  def create
    @comment = Comment.new(params[:comment])
    @comment.presenter = current_presenter
    @session = @comment.review.session

    if params[:commit] != 'Preview' && @comment.save
      Postman.notify_comment_creation(@comment)
      redirect_to @comment.review.session, notice: 'Comment was successfully created.'
    else
      @session = @comment.review.session
      @current_presenter_has_voted_for_this_session = Vote.presenter_has_voted_for?(current_presenter.id, @comment.review.session.id) 
      @my_vote = Vote.vote_of_presenter_for(current_presenter.id, @comment.review.session.id) 
      @new_comment=@comment
      render template: 'sessions/show'
    end
  end

  def update
    @comment = Comment.find(params[:id])
    @session = @comment.review.session

    if params[:commit] == 'Preview' 
      @comment.assign_attributes(params[:comment])
      @session = @comment.review.session
      @current_presenter_has_voted_for_this_session = Vote.presenter_has_voted_for?(current_presenter.id, @comment.review.session.id) 
      @my_vote = Vote.vote_of_presenter_for(current_presenter.id, @comment.review.session.id) 
      render template: 'sessions/show'
    else 
      if @comment.update_attributes(params[:comment])
        redirect_to @comment.review.session, notice: 'Comment was successfully created.'
      else
        render action: "edit"
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    redirect_to comments_url
  end
end
