class AddSlugToForum < ActiveRecord::Migration
  def change
    add_column :forums, :slug, :string
    ActiveRecord::Base.record_timestamps = false 
    Forum.find_each(&:save)
    ActiveRecord::Base.record_timestamps = true 
  end
end
