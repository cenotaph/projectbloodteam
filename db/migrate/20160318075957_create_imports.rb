class CreateImports < ActiveRecord::Migration
  def change
    drop_table :imports
    create_table :imports do |t|
      t.references :agent, index: true#, foreign_key: true
      t.string :year
      t.string :category

      t.timestamps null: false
    end
    add_attachment :imports, :csvfile
  end
end
