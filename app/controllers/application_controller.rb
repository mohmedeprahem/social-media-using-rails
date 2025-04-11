class ApplicationController < ActionController::API
  before_action :authorized
  around_action :handle_errors

  def encode_token(payload)
    payload[:exp] = 7.days.from_now.to_i
    JWT.encode(payload, 'hellomars1211')
  end

  def decoded_token
      header = request.headers['Authorization']
      if header
          token = header.split(" ")[1]
          begin
              JWT.decode(token, 'hellomars1211', true, algorithm: 'HS256')
          rescue JWT::DecodeError
              nil
          end
      end
  end

  def current_user
      if decoded_token
          user_id = decoded_token[0]['user_id']
          user = User.find_by(id: user_id)
          return user
      end
  end

  def authorized
      unless !!current_user
      render json: { message: 'Please log in' }, status: :unauthorized
      end
  end

  protected

  def handle_errors
    yield
  rescue ActiveRecord::RecordNotFound => e
    render_not_found(e.message)
  rescue ActiveRecord::RecordInvalid => e
    render_unprocessable_entity(e.record.errors)
  rescue StandardError => e
    Rails.logger.error(e)
    render_internal_error("Internal server error")
  end

  def render_success(data, message = nil, status: :ok)
    render json: {
      success: true,
      message: message,
      data: data,
      status: status
    }, status: status
  end

  def render_unauthorized(message = "Unauthorized")
    render json: {
      success: false,
      message: message,
      status: 401
    }, status: :unauthorized
  end

  def render_unprocessable_entity(errors)
    render json: {
      success: false,
      message: "Validation failed",
      errors: errors.full_messages,
      status: 422
    }, status: :unprocessable_entity
  end

  def render_not_found(message = "Not found")
    render json: {
      success: false,
      message: message,
      status: 404
    }, status: :not_found
  end

  def render_internal_error(message = "Internal server error")
    render json: {
      success: false,
      message: message,
      status: 500
    }, status: :internal_server_error
  end
end
