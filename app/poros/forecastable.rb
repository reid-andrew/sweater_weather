module Forecastable
  private

  def calculate_image_url(variable)
    "http://openweathermap.org/img/wn/#{variable}@2x.png"
  end

  def find_time(time, zone, format)
    Time.at(time).in_time_zone(zone).strftime(format)
  end
end
