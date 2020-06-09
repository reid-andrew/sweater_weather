class CurrentWeather
  include Forecastable

  def self.forecast(weather)
    forecast = []
    forecast << CurrentWeather.new(weather)
  end

  def initialize(weather)
    @time = find_time(weather[:current][:dt], weather[:timezone], '%l:%M %p, %B%e')
    @current_temp = weather[:current][:temp]
    @high = weather[:daily][0][:temp][:max]
    @low = weather[:daily][0][:temp][:min]
    @description = weather[:current][:weather][0][:description]
    @image = calculate_image_url(weather[:current][:weather][0][:icon])
  end
end
