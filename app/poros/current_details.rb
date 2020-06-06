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

  def uv_index_interpreted
    return 'extreme' if @weather[:current][:uvi] >= 11

    return 'very high' if @weather[:current][:uvi] >= 8

    return 'high' if @weather[:current][:uvi] >= 6

    return 'moderate' if @weather[:current][:uvi] >= 3

    'low'
  end

  def sunrise
    Time.at(@weather[:current][:sunrise]).strftime('%l:%M %p')
  end

  def sunset
    Time.at(@weather[:current][:sunset]).strftime('%l:%M %p')
  end
end
