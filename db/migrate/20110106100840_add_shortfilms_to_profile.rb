class AddShortfilmsToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :shortfilms, :boolean
  end

  def self.down
    remove_column :profiles, :shortfilms
  end
end
