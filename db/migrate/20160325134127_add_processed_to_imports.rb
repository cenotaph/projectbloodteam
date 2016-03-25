class AddProcessedToImports < ActiveRecord::Migration
  def change
    add_column :imports, :processed, :boolean, null: false, default: false
  end
end
