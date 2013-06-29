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
  end

  def create
    @comment = Comment.new(params[:comment])
    @comment.presenter = current_presenter
    @session = @comment.review.session
    @review  = @comment.review

    if params[:commit] != 'Preview' && @comment.save
      Postman.notify_comment_creation(@comment)
      redirect_to @comment, notice: 'Comment was successfully created.'
    else
      @session = @comment.review.session
      render action: "new"
    end
  end

  def update
    @comment = Comment.find(params[:id])
    @session = @comment.review.session

    if params[:commit] == 'Preview' 
      @comment.assign_attributes(params[:comment])
      render action: "edit"
    else 
      if @comment.update_attributes(params[:comment])
        redirect_to @comment, notice: 'Comment was successfully updated.'
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
