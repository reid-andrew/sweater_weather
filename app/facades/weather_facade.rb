class WeatherFacade
  attr_reader :id

  def initialize(location)
    @location = location
    @geocode ||= GeocodingService.find_geocode(location)
    @weather ||= OpenWeatherService.find_weather(@geocode[:results][0][:geometry][:location])
    @id = "#{location} - #{@weather[:current][:dt]}"
  end

  def city
    @location.gsub(/,.*/, '').capitalize
  end

  def state
    @location.gsub(/.*,/, '').gsub(' ', '').upcase
  end

  def country
    @geocode[:results][0][:address_components][3][:long_name]
  end

  def time
    Time.at(@weather[:current][:dt]).strftime('%l:%M %p, %B%e')
  end

  def current_temp
    @weather[:current][:temp]
  end

  def forecast_high
    @weather[:daily][0][:temp][:max]
  end

  def forecast_low
    @weather[:daily][0][:temp][:min]
  end


end
