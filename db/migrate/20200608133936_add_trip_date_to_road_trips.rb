class AddTripDateToRoadTrips < ActiveRecord::Migration[5.1]
  def change
    add_column :road_trips, :trip_date, :datetime
  end
end
