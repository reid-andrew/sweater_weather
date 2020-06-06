class WeatherSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id,
             :location,
             :current_weather,
             :current_details,
             :hourly_forecast,
             :daily_forecast
end
