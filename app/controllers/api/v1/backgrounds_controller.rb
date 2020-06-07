class Api::V1::BackgroundsController < ApplicationController
  def index
    render json: BackgroundImageSerializer.new(
      BackgroundPhoto.new(background_params[:location])
    )
  end

  private

  def background_params
    params.permit(:location)
  end
end
