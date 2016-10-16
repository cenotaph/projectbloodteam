class MoveGeolocationsToPolymorphic < ActiveRecord::Migration[5.0]
  def change
    create_table :geolocation_items do |t| 
      t.integer :geolocation_id
      t.integer :item_id
      t.string :item_type
      t.timestamps
    end
    add_index :geolocation_items, [:item_id, :item_type]
    [Activity, Bar, Brewing, Concert,  Event, Gambling, Grocery,  Movie, Musicplayed, Restaurant, Takeaway, Tvseries].each do |category|
      hasloc = category.where("geolocation_id is not null")
      hasloc.each do |h|
        GeolocationItem.create(geolocation_id: h.geolocation_id, item_type: category.to_s, item_id: h.id)
      end
    end
  end
end
