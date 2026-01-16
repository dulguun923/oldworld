class SharesController < ApplicationController
  before_action :authorize_request
  before_action :set_post

  def create
    share = @current_user.shares.build(post: @post)
    if share.save
      render json: {
        id: share.id,
        post_id: share.post_id,
        user_id: share.user_id,
        created_at: share.created_at
      }, status: :created
    else
      render json: { error: share.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def destroy
    share = @current_user.shares.find_by(post: @post)
    if share
      share.destroy
      render json: { message: "Share removed" }, status: :ok
    else
      render json: { error: "Share not found" }, status: :not_found
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Post not found" }, status: :not_found
  end
end
