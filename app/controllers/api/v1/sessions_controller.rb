class Api::V1::SessionsController < ApplicationController
  def create
    user = User.find_by(email: session_params[:email])
    if user.present? && user.authenticate(params[:password])
      session[:user_id] = user.id
      render json: UsersSerializer.new(user), status: :created
    elsif !session_params[:email] || !session_params[:password]
      render '/login/fill_fields.json', status: :bad_request
    else
      render '/login/register.json', status: :bad_request
    end
  end

  private

  def session_params
    params.permit(:email, :password)
  end
end
