class AddMissingmilesToViews < ActiveRecord::Migration
  def change
    add_column :views, :miles_station, :string, default: 'Station'
    add_column :views, :miles_gasamount, :string, default: 'Amount'
    add_column :views, :miles_ppg, :string, default: 'Price per gallon'
    add_column :views, :miles_miles, :string, default: 'Miles'
    add_column :views, :miles_cost, :string, default: 'Cost'
    add_column :views, :miles_location, :string, default: 'Location'
  end
end
