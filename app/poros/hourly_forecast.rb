class HourlyForecast
  include Forecastable

  def self.forecast(weather)
    weather[:hourly][0..7].map do |hour|
      HourlyForecast.new(hour, weather[:timezone])
    end
  end

  def initialize(weather, zone)
    @time = find_time(weather[:dt], zone, '%l %p')
    @temp = weather[:temp]
    @image = weather[:weather][0][:icon]
  end
end
