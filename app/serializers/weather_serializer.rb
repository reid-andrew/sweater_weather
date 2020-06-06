class WeatherSerializer
  include FastJsonapi::ObjectSerializer
  attributes :city, :state, :country, :time, :current_temp, :forecast_high, :forecast_low
end
