class AddFielsToAgents < ActiveRecord::Migration
  def change
    add_column :agents, :current_sign_in_at, :datetime
    add_column :agents, :last_sign_in_at, :datetime
    add_column :agents, :current_sign_in_ip, :string
    add_column :agents, :last_sign_in_ip, :string
    add_column :agents, :sign_in_count, :integer
    
  end
end
