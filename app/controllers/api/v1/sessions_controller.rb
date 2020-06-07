class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user.present? && user.authenticate(params[:password])
      session[:user_id] = user.id
      render json: UsersSerializer.new(user), status: :created
    else
      render json: UsersSerializer.new(user), status: :bad_request
    end
  end

  private

  def session_params
    params.permit(:email, :password)
  end
end
