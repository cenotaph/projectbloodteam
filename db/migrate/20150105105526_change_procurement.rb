class ChangeProcurement < ActiveRecord::Migration
  def change
    change_column :musics,  :procurement, :string
  end
end
