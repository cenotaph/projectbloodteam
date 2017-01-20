 # -*- encoding : utf-8 -*-
ThinkingSphinx::Index.define :videogame, :with => :active_record, delta: true do
  indexes source, comment
  indexes master_videogame(:title), :as => :title
  indexes master_videogame(:creator), :as => :creator
  has agent_id, master_videogame_id, created_at, updated_at
end