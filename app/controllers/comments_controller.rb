class CommentsController < ApplicationController
  def new
    @comment = Comment.new
    @comments = Comment.order('created_at DESC')
  end

  def create
    if current_user
      @comment = current_user.comments.build(comment_params)
      if @comment.save
        flash[:success] = 'Your comment was successfully posted!'
      else
        flash[:error] = 'Your comment cannot be saved.'
      end
      format.html { redirect_to root_url }
      format.js
    else
      format.html { redirect_to root_url }
      format.js { render nothing: true }
    end
    redirect_to root_url
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
