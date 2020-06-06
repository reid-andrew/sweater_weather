class CurrentWeather
  def self.forecast(weather)
    forecast = []
    forecast << CurrentWeather.new(weather)
  end

  def initialize(weather)
    @time = Time.at(weather[:current][:dt]).strftime('%l:%M %p, %B%e')
    @current_temp = weather[:current][:temp]
    @high = weather[:daily][0][:temp][:max]
    @low = weather[:daily][0][:temp][:min]
    @description = weather[:current][:weather][0][:description]
    @image = "http://openweathermap.org/img/wn/#{weather[:current][:weather][0][:icon]}@2x.png"
  end
end
