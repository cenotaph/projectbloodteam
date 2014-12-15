class Location < ActiveRecord::Migration
  def self.up
    create_table :geolocations do |t|
      t.string :address
      t.float :latitude
      t.float :longitude
      t.timestamps
    end
  end

  def self.down
    drop table :geolocations
  end
end
