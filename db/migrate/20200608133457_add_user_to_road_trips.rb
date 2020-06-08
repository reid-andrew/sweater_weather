class AddUserToRoadTrips < ActiveRecord::Migration[5.1]
  def change
    add_reference :road_trips, :user, index: true
  end
end
