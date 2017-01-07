class AddDiscogstokenToAgents < ActiveRecord::Migration[5.0]
  def change
    add_column :agents, :discogs_token, :binary
  end
end
