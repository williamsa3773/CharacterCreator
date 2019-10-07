class AuthenticationController < ApplicationController
  before_action :authorize_request, except: :login

  # POST /auth/login
  def login
    @user = User.find_by_username(params[:username])
    if @user.authenticate(params[:password]) # authenticate method provided by Bcrypt and 'has_secure_password'
      token = encode(id: @user.id, username: @user.username)
      render json: { token: token , user: {id: @user.id, username: @user.username}}, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  def verify
    @user = {
      id: @current_user[:id],
      username: @current_user[:username],
      email: @current_user[:email]
    }

    render json: @user
  end

  private

  def login_params
    params.permit(:username, :password)
  end
end
