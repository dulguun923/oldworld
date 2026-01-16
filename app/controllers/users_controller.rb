class UsersController < ApplicationController
  before_action :authorize, only: [:me]

  def register
    user = User.new(user_params)

    if user.save
      token = encode_token({ user_id: user.id })
      render json: { user: user, token: token }
    else
      render json: { errors: user.errors.full_messages }
    end
  end

  def login
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      token = encode_token({ user_id: user.id })
      render json: { user: user, token: token }
    else
      render json: { error: "Invalid email or password" }, status: 401
    end
  end

  def me
    decoded = decode_token
    user = User.find(decoded[0]["user_id"])
    render json: user
  end

  def show
    user = User.find(params[:id])
    render json: user
  end

  def update
    decoded = decode_token
    user = User.find(decoded[0]["user_id"])
    
    if user.update(user_params)
      render json: user
    else
      render json: { errors: user.errors.full_messages }, status: 422
    end
  end

  private

  def user_params
    params.permit(:username, :email, :password, :bio, :avatar_url)
  end
end
