class Api::V1::BackgroundsController < ApplicationController
  def index
    BackgroundPhoto.new(background_params)
  end

  private

  def background_params
    params.permit(:location)
  end
end
