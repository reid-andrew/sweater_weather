class HourlyForecast
  def self.forecast(weather)
    forecast = []
    weather[:hourly][0..7].each { |hour| forecast << HourlyForecast.new(hour) }
    forecast
  end

  def initialize(weather)
    @time = Time.at(weather[:dt]).strftime('%l %p')
    @temp = weather[:temp]
    @image = weather[:weather][0][:icon]
  end
end
