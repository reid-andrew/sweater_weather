class Api::V1::ForecastController < ApplicationController
  def index
    render json: WeatherSerializer.new(WeatherFacade.new(forecast_params[:city],
                                                         forecast_params[:state]))
  end

  private

  def forecast_params
    params.permit(:city, :state)
  end
end
