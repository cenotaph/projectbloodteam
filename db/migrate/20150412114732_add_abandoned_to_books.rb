class AddAbandonedToBooks < ActiveRecord::Migration
  def change
    add_column :books, :abandoned, :boolean
    add_column :books, :abandoned_at, :date
  end
end
