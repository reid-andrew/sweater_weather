class Api::V1::ForecastController < ApplicationController
  def index
    render json: WeatherSerializer.new(
      WeatherReport.new(forecast_params[:location])
    )
  end

  private

  def forecast_params
    params.permit(:location)
  end
end
