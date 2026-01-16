class ApplicationController < ActionController::API

  def encode_token(payload)
    JWT.encode(payload, 'secret_key')
  end

  def decode_token
    auth_header = request.headers['Authorization']
    return unless auth_header

    token = auth_header.split(' ')[1]
    begin
      JWT.decode(token, 'secret_key', true, algorithm: 'HS256')
    rescue
      nil
    end
  end

  def authorize
    decoded = decode_token
    render json: { error: "Unauthorized" }, status: 401 unless decoded
  end

  def authorize_request
    decoded = decode_token
    if decoded
      @current_user = User.find(decoded[0]["user_id"])
    else
      render json: { error: "Unauthorized" }, status: 401
    end
  end

end
