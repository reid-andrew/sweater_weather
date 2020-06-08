class Foodie
  def initialize(params)
    @geocode = GeocodingService.find_geocode(params[:end])
    @end_location = params[:end]
    @travel_time = ''
    @forecast = ''
    @restaurant = ''
  end
end
