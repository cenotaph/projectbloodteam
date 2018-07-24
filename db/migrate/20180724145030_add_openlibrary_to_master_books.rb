class AddOpenlibraryToMasterBooks < ActiveRecord::Migration[5.1]
  def change
    add_column :master_books, :open_library, :string
  end
end
