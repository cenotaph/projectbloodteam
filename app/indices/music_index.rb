 # -*- encoding : utf-8 -*-
ThinkingSphinx::Index.define :music, :with => :active_record do
  indexes source, comment
  indexes master_music(:artist), :as => :artist
  indexes master_music(:title), :as => :title
  indexes master_music(:label), :as => :label
  has agent_id, master_music_id, created_at, updated_at
end