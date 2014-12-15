class AddVenueaddressToConcerts < ActiveRecord::Migration
  def self.up
    add_column :concerts, :venue_address, :string
    add_column :events, :venue_address, :string
    add_column :movies, :venue_address, :string
    add_column :activities, :venue_address, :string
    add_column :musicplayed, :venue_address, :string
    execute('alter table concerts modify venue_address varchar(255) after venue')
    execute('alter table events modify venue_address varchar(255) after location')
    execute('alter table movies modify venue_address varchar(255) after location')
    execute('alter table activities modify venue_address varchar(255) after location')  
    execute('alter table musicplayed modify venue_address varchar(255) after location')              
  end

  def self.down
    remove_column :events, :venue_address
    remove_column :concerts, :venue_address
    remove_column :movies, :venue_address
    remove_column :activities, :venue_address
    remove_column :musicplayed, :venue_address            
  end
  
end
