class CreateMasterTvseries < ActiveRecord::Migration
  def change
    create_table :master_tvseries do |t|
      t.string :title
      t.integer :year
      t.string :image_file_name
      t.integer :image_file_size
      t.string :image_content_type
      t.integer :height
      t.integer :width
      t.datetime :image_updated_at
      t.boolean :delta
      t.string :slug
      t.integer :imdbcode

      t.timestamps
    end
  end
end
