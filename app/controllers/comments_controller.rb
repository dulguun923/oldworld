class CommentsController < ApplicationController
  before_action :authorize_request

  def index
    post = Post.find(params[:post_id])
    comments = post.comments.includes(:user).order(created_at: :desc)
    render json: comments.map { |c|
      {
        id: c.id,
        body: c.body,
        user_email: c.user.email,
        user_id: c.user.id,
        created_at: c.created_at
      }
    }
  end

  def create
    post = Post.find(params[:post_id])
    comment = post.comments.build(comment_params)
    comment.user = @current_user

    if comment.save
      render json: {
        id: comment.id,
        body: comment.body,
        user_email: @current_user.email,
        user_id: @current_user.id,
        created_at: comment.created_at
      }, status: :created
    else
      render json: { error: comment.errors.full_messages }, status: 422
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
