class CreateImportbacklogs < ActiveRecord::Migration
  def change
    create_table :importbacklogs do |t|
      t.references :import, index: true, foreign_key: true
      t.text :csvline
      t.boolean :imported, null: false, default: false
      t.references :pbtentry, :polymorphic => true

      t.timestamps null: false
    end
  end
end
