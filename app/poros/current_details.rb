class CurrentDetails
  include Forecastable

  def self.forecast(weather)
    [CurrentDetails.new(weather)]
  end

  def initialize(weather)
    @feels_like = weather[:current][:feels_like]
    @humidity = weather[:current][:humidity]
    @visibility = weather[:current][:visibility]
    @uv_index = weather[:current][:uvi]
    @uv_index_interpreted = uv_index_interpreted(weather)
    @sunrise = find_time(weather[:current][:sunrise],
                         weather[:timezone], '%l:%M %p')
    @sunset = find_time(weather[:current][:sunset],
                        weather[:timezone], '%l:%M %p')
    @description = weather[:current][:weather][0][:description]
    @image = calculate_image_url(weather[:current][:weather][0][:icon])
  end

  private

  def uv_index_interpreted(weather)
    return 'extreme' if weather[:current][:uvi] >= 11

    return 'very high' if weather[:current][:uvi] >= 8

    return 'high' if weather[:current][:uvi] >= 6

    return 'moderate' if weather[:current][:uvi] >= 3

    'low'
  end
end
