class CreateReferences < ActiveRecord::Migration
  def change
    create_table :references do |t|
      t.references :source, polymorphic: true, index: true
      t.references :reference, polymorphic: true, index: true
      t.text :comment

      t.timestamps null: false
    end
  end
end
