class DailyForecast
  include Forecastable

  def self.forecast(weather)
    weather[:daily][0..4].map do |day|
      DailyForecast.new(day, weather[:timezone])
    end
  end

  def initialize(weather, zone)
    @day = find_time(weather[:dt], zone, '%A')
    @description = weather[:weather][0][:description]
    @image = calculate_image_url(weather[:weather][0][:icon])
    @precipitation = calculate_precipitation(weather)
    @high_temp = weather[:temp][:max]
    @low_temp = weather[:temp][:min]
  end

  private

  def calculate_precipitation(weather)
    precip = 0
    precip += weather[:snow] if weather[:snow]
    precip += weather[:rain] if weather[:rain]
    precip
  end
end
