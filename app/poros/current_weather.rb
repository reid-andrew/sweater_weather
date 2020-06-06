class CurrentWeather
  def initialize(weather)
    @weather = weather
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

  def current_description
    @weather[:current][:weather][0][:description]
  end

  def image
    "http://openweathermap.org/img/wn/#{@weather[:current][:weather][0][:icon]}@2x.png"
  end
end
