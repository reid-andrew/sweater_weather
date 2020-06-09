class Api::V1::RoadTripController < ApplicationController
  def create
    user = User.find_by(api_key: trip_params[:api_key])
    if !user
      render '/road_trip/unauthorized.json', status: :unauthorized
    elsif !trip_params[:origin] || !trip_params[:destination]
      render '/road_trip/fill_fields.json', status: :bad_request
    else
      roadtrip = RoadTrip.create_trip(trip_params[:origin],
                                      trip_params[:destination], user)
      render json: RoadTripSerializer.new(roadtrip), status: :ok
    end
  end

  private

  def trip_params
    params.permit(:origin, :destination, :api_key)
  end
end
