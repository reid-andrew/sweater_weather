class FoodieSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id,
              :end_location,
              :travel_time,
              :forecast,
              :restaurant
end
