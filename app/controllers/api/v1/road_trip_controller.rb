class Api::V1::RoadTripController < ApplicationController
  def create
    user = User.find_by(api_key: road_trip_params[:api_key])
    if !user
      render json: RoadTripSerializer.new(user), status: :bad_request
    else
      roadtrip = RoadTrip.create_road_trip(road_trip_params[:origin],
                                           road_trip_params[:destination],
                                           user)
      render json: RoadTripSerializer.new(roadtrip), status: :ok
    end
  end

  private

  def road_trip_params
    params.permit(:origin, :destination, :api_key)
  end
end
