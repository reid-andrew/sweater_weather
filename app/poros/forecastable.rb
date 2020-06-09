module Forecastable
  private

  def calculate_image_url(variable)
    "http://openweathermap.org/img/wn/#{variable}@2x.png"
  end
end
