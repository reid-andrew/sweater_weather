class CurrentDetails
  def initialize(weather)
    @weather = weather
  end

  def feels_like
    @weather[:current][:feels_like]
  end

  def humidity
    @weather[:current][:humidity]
  end

  def visibility
    @weather[:current][:visibility]
  end

  def uv_index
    @weather[:current][:uvi]
  end

  def sunrise
    Time.at(@weather[:current][:sunrise]).strftime('%l:%M %p')
  end

  def sunset
    Time.at(@weather[:current][:sunset]).strftime('%l:%M %p')
  end
end
