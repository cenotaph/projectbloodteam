class AddMasterdiscogsIdToMasterMusics < ActiveRecord::Migration
  def change
    add_column :master_musics, :masterdiscogs_id, :integer
    add_column :master_musics, :converted, :boolean, default: false, null: false
  end
end
