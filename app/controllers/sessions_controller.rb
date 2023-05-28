class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = encode_token(user_id: user.id)
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def destroy
    # Any additional logout logic you may have (e.g., invalidating tokens)
    render json: { message: 'Logged out successfully' }, status: :ok
  end

  private

  def encode_token(payload)
    JWT.encode(payload, 'your_secret_key')
  end
end
