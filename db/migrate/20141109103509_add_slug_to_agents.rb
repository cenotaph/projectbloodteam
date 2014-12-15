class AddSlugToAgents < ActiveRecord::Migration
  def change
    add_column :agents, :slug, :string
    Agent.find_each(&:save)
  end
end
