class RoadTripSerializer
  include FastJsonapi::ObjectSerializer
  attributes :origin,
             :destination,
             :travel_time,
             :forecast_temp,
             :forecast_description,
             :trip_date
end
