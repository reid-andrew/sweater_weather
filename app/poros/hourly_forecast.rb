class HourlyForecast
  include Forecastable

  def self.forecast(weather)
    forecast = []
    weather[:hourly][0..7].each { |hour| forecast << HourlyForecast.new(hour, weather[:timezone]) }
    forecast
  end

  def initialize(weather, zone)
    @time = find_time(weather[:dt], zone, '%l %p')
    @temp = weather[:temp]
    @image = weather[:weather][0][:icon]
  end
end
