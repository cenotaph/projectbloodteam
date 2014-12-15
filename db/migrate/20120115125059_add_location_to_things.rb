class AddLocationToThings < ActiveRecord::Migration
  def self.up
    add_column :activities, :geolocation_id, :integer
    add_column :airports, :geolocation_id, :integer
    add_column :bars, :geolocation_id, :integer
    add_column :concerts, :geolocation_id, :integer
    add_column :events, :geolocation_id, :integer
    add_column :gambling, :geolocation_id, :integer
    add_column :groceries, :geolocation_id, :integer
    add_column :movies, :geolocation_id, :integer
    add_column :musicplayed, :geolocation_id, :integer
    add_column :restaurants, :geolocation_id, :integer
    add_column :takeaway, :geolocation_id, :integer
    add_column :brewing, :geolocation_id, :integer
                                    
  end

  def self.down
    remove_column :activities, :geolocation_id
    remove_column :airports, :geolocation_id
    remove_column :bars, :geolocation_id
    remove_column :concerts, :geolocation_id
    remove_column :events, :geolocation_id
    remove_column :gambling, :geolocation_id
    remove_column :groceries, :geolocation_id
    remove_column :movies, :geolocation_id
    remove_column :musicplayed, :geolocation_id
    remove_column :restaurants, :geolocation_id
    remove_column :takeaway, :geolocation_id
    remove_column :brewing, :geolocation_id    
  end
end
