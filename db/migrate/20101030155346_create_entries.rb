class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.references :agent
      t.integer :entry_id
      t.string :entry_type
      t.string :action

      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end
