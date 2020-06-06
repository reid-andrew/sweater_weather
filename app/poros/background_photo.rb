class BackgroundPhoto
  attr_reader :id, :photos

  def initialize(location)
    @id = location
    @photo_link = PhotoService.find_photo(location)
  end

  def photos
    [{photo: @photo_link}]
  end
end
