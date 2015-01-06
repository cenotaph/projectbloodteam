class AddAuditedToMasterMovies < ActiveRecord::Migration
  def change
    add_column :master_movies, :audited, :boolean, null: false, default: false
  end
end
