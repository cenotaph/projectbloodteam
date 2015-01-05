class AddEnglishTitleToMasterMovies < ActiveRecord::Migration
  def change
    add_column :master_movies, :english_title, :string
  end
end
