class WeatherReport
  attr_reader :id

  def initialize(location)
    @geocode = GeocodingService.find_geocode(location)
    @weather_data = OpenWeatherService.find_weather(
      @geocode[:results][0][:geometry][:location]
    )
    @location = location
    @id = "#{location} - #{@weather_data[:current][:dt]}"
  end

  def weather
    {
      location: Location.location(@location, @geocode),
      current_weather: CurrentWeather.forecast(@weather_data),
      current_details: CurrentDetails.forecast(@weather_data),
      hourly_forecast: HourlyForecast.forecast(@weather_data),
      daily_forecast: DailyForecast.forecast(@weather_data)
    }
  end
end
