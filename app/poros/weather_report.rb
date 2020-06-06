class WeatherReport
  attr_reader :id, :weather

  def initialize(location)
    @geocode ||= GeocodingService.find_geocode(location)
    @weather ||= OpenWeatherService.find_weather(@geocode[:results][0][:geometry][:location])
    @id = "#{location} - #{@weather[:current][:dt]}"
    @location = Location.location(location, @geocode)
    @current_weather ||= CurrentWeather.forecast(@weather)
    @current_details ||= CurrentDetails.forecast(@weather)
    @hourly_forecast ||= HourlyForecast.forecast(@weather)
    @daily_forecast ||= DailyForecast.forecast(@weather)
  end

  def weather
    {
      location: @location,
      current_weather: @current_weather,
      current_details: @current_details,
      hourly_forecast: @hourly_forecast,
      daily_forecast: @daily_forecast
    }
  end
end
