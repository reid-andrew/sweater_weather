class PhotoService
  class << self
    include Parseable

    def find_photo_reference(location)
      place = parse_json(connection(location))
      place[:candidates][0][:photos][0][:photo_reference]
    end

    private

    def connection(location)
      url = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json'
      Faraday.get(url) do |req|
        req.params['input'] = location
        req.params['key'] = ENV['GOOGLE_GEOCODING_KEY']
        req.params['inputtype'] = 'textquery'
        req.params['fields'] = 'photos'
      end
    end
  end
end
