class WeatherReport
  attr_reader :id

  def initialize(location)
    @geocode ||= GeocodingService.find_geocode(location)
    @weather ||= OpenWeatherService.find_weather(@geocode[:results][0][:geometry][:location])
    @id = "#{location} - #{@weather[:current][:dt]}"
    @location = Location.new(location, @geocode)
    @current_weather ||= CurrentWeather.new(@weather)
    @current_details ||= CurrentDetails.new(@weather)
    @hourly_forecast ||= HourlyForecast.forecast(@weather)
    @daily_forecast ||= DailyForecast.forecast(@weather)
  end

  def location
    {
      city: @location.city,
      state: @location.state,
      country: @location.country
    }
  end

  def current_weather
    {
      time: @current_weather.time,
      current_temp: @current_weather.current_temp,
      high: @current_weather.forecast_high,
      low: @current_weather.forecast_low,
      description: @current_weather.current_description,
      image: @current_weather.image
    }
  end

  def current_details
    {
      description: @current_weather.current_description,
      image: @current_weather.image,
      feels_like: @current_details.feels_like,
      humidity: @current_details.humidity,
      visibility: @current_details.visibility,
      uv_index: @current_details.uv_index,
      sunrise: @current_details.sunrise,
      sunset: @current_details.sunset
    }
  end

  def hourly_forecast
    {
      attributes: @hourly_forecast
    }
  end
end
