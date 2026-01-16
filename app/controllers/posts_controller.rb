class PostsController < ApplicationController
  before_action :authorize_request

  def index
    posts = Post.search(params[:q]).includes(:user, :tags, :shares).order(created_at: :desc)
    render json: posts.map { |p|
      {
        id: p.id,
        title: p.title,
        body: p.body,
        user_email: p.user.email,
        user_avatar_url: p.user.avatar_url,
        tags: p.tags.map(&:name),
        comments_count: p.comments.count,
        shares_count: p.shares.count,
        shared_by_current_user: p.shared_by?(@current_user),
        created_at: p.created_at
      }
    }
  end

  def create
    post = @current_user.posts.build(post_params)
    if post.save
      render json: {
        id: post.id,
        title: post.title,
        body: post.body,
        user_email: @current_user.email,
        user_avatar_url: @current_user.avatar_url,
        tags: post.tags.map(&:name),
        comments_count: 0,
        shares_count: 0,
        shared_by_current_user: false,
        created_at: post.created_at
      }, status: :created
    else
      render json: { error: post.errors.full_messages }, status: 422
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
