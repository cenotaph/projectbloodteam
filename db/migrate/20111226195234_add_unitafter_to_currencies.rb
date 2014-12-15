class AddUnitafterToCurrencies < ActiveRecord::Migration
  def self.up
    add_column :currencies, :unitafter, :boolean, :null => false, :default => false
    execute("update currencies set unitafter = true where id in (3, 13, 16, 17)")
  end

  def self.down
    remove_column :currencies, :unitafter
  end
end
