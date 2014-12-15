class CreateExchanges < ActiveRecord::Migration
  def self.up
    create_table :exchanges do |t|
      t.integer :basecurrency_id
      t.integer :othercurrency_id
      t.boolean :entire_year
      t.date :sample_date
      t.timestamps
    end
    add_column :exchanges, :rate, :double
  end

  def self.down
    drop_table :exchanges
  end
end
