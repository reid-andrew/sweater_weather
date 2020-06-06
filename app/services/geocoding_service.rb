class GeocodingService
  class << self
    def find_coordinates(address)
      geocode = parse_json(connection(address))
      return geocode[:results][0][:geometry][:location] if geocode[:results][0]

      geocode
    end

    private

    def connection(address)
      url = 'https://maps.googleapis.com/maps/api/geocode/json'
      Faraday.get(url) do |req|
        req.params['address'] = address.gsub(' ', '+')
        req.params['key'] = ENV['GOOGLE_GEOCODING_KEY']
      end
    end

    def parse_json(response)
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
