class CommentsController < ApplicationController
  def index
    @comments = Comment.all
  end

  def make_parameters_for_show_session(comment)
    @session = comment.review.session
    @current_presenter_has_voted_for_this_session = Vote.presenter_has_voted_for?(current_presenter.id, comment.review.session.id) 
    @my_vote = Vote.vote_of_presenter_for(current_presenter.id, comment.review.session.id) 
  end

  def show
    make_parameters_for_show_session(Comment.find(params[:id]))
    render template: 'sessions/show'
  end

  def new
    @review  = Review.find(params[:review_id])
    @session = @review.session
    @new_comment =  @review.comments.build()
    @new_comment.presenter = current_presenter
  end

  def edit
    @edit_comment = Comment.find(params[:id])
    @anchor="session_review_#{@edit_comment.review.id}_comment_#{@edit_comment.id}"
    make_parameters_for_show_session(@edit_comment)
    render template: 'sessions/show'
  end

  def create
    @new_comment = Comment.new(params[:comment])
    @new_comment.presenter = current_presenter
    make_parameters_for_show_session(@new_comment)

    if params[:commit] != 'Preview' && @new_comment.save
      Postman.notify_comment_creation(@new_comment)
      redirect_to @new_comment.review.session, notice: 'Comment was successfully created.'
    else
      @anchor="session_review_#{@new_comment.review.id}_comment_new"
      render template: 'sessions/show'
    end
  end

  def update
    @edit_comment = Comment.find(params[:id])
    make_parameters_for_show_session(@edit_comment)

    if params[:commit] == 'Preview' 
      @edit_comment.assign_attributes(params[:comment])
      @anchor="session_review_#{@edit_comment.review.id}_comment_#{@edit_comment.id}"
      render template: 'sessions/show'
    else 
      if @edit_comment.update_attributes(params[:comment])
        redirect_to @edit_comment.review.session, notice: 'Comment was successfully created.'
      else
        render template: 'sessions/show'
      end
    end
  end

end
