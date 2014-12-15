class AddSecurityToAgents < ActiveRecord::Migration
  def self.up
    add_column :agents, :security, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :agents, :security
  end
end
