class Userimage < ActiveRecord::Migration
  def self.up
    create_table :userimages do |t|
      t.integer :entry_id
      t.string  :entry_type
      t.string  :image_file_name
      t.string  :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.boolean :primary
      t.timestamps
    end
    
  end

  def self.down
    drop_table :userimages
  end
end
