class AddImageRemoteUrlToUserimages < ActiveRecord::Migration
  def self.up
    add_column :userimages, :image_remote_url, :string
  end

  def self.down
    remove_column :userimages, :image_remote_url
  end
end
