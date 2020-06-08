class CreateRoadTrips < ActiveRecord::Migration[5.1]
  def change
    create_table :road_trips do |t|
      t.string :origin
      t.string :destination
      t.string :travel_time
      t.float :forecast_temp
      t.string :forecast_description
      t.timestamps
    end
  end
end
