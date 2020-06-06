class WeatherReport
  attr_reader :id

  def initialize(location)
    @geocode ||= GeocodingService.find_geocode(location)
    @weather ||= OpenWeatherService.find_weather(@geocode[:results][0][:geometry][:location])
    @id = "#{location} - #{@weather[:current][:dt]}"
    @location = Location.new(location, @geocode)
    @current_weather ||= CurrentWeather.new(@weather)
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
      details: @current_weather.current_description
    }
  end
end
