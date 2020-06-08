class Api::V1::FoodieController < ApplicationController
  def index
    render json: FoodieSerializer.new(Foodie.new(foodie_params))
  end

  private

  def foodie_params
    params.permit(:start, :end, :search)
  end
end
