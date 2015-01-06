class RenameIncorrectViews < ActiveRecord::Migration
  def change
    rename_column :views, :miles_gasamount, :mile_gasamount
    rename_column :views, :miles_station, :mile_station
    rename_column :views, :miles_ppg, :mile_ppg
    rename_column :views, :miles_cost, :mile_cost
    rename_column :views, :miles_miles, :mile_miles
    rename_column :views, :miles_location, :mile_location
  end
end
