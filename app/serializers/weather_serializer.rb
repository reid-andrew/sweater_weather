class WeatherSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :location, :current_weather
  # attributes :id, :city, :state, :country, :time, :current_temp, :forecast_high, :forecast_low
end
