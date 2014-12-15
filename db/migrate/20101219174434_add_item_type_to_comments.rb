class AddItemTypeToComments < ActiveRecord::Migration
  def self.up
    execute "alter table comments change category item_type varchar(48);"
  end

  def self.down
    execute "alter table comments change item_type category varchar(48);"
  end
end
