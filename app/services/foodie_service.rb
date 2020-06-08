class FoodieService
  class << self
    include Parseable

    def find_restaurant(lat, lon, search)
      restaurant = parse_json(connection(lat, lon, search))
      {
        name: restaurant[:restaurants][0][:restaurant][:name],
        address: restaurant[:restaurants][0][:restaurant][:location][:address]
      }
    end

    private

    def connection(lat, lon, search)
      url = 'https://developers.zomato.com/api/v2.1/search'
      Faraday.get(url) do |req|
        req.headers['user-key'] = ENV['ZOMATO_API_KEY']
        req.params['lat'] = lat
        req.params['lon'] = lon
        req.params['q'] = search
      end
    end
  end
end
