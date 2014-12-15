class AddVenueAddressToBrewings < ActiveRecord::Migration
  def self.up
    add_column :brewing, :venue_address, :string
  end

  def self.down
    remove_column :brewing, :venue_address
  end
end
