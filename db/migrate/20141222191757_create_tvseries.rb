class CreateTvseries < ActiveRecord::Migration
  def change
    create_table :tvseries do |t|
      t.references :agent, index: true
      t.references :master_tvseries, index: true
      t.date :started
      t.date :finished
      t.integer :season
      t.float :rating
      t.text :comment
      t.boolean :first
      t.string :userimage
      t.string :location
      t.string :venue_address
      t.references :geolocation, index: true

      t.timestamps
    end
    add_column :categories, :tvseries, :string, default: "TV Series"
    add_column :views, :tvseries_rating, :string, default: 'Rating'
    add_column :views, :tvseries_comment, :string, default: 'Comment'
    
  end
end
