 # -*- encoding : utf-8 -*-
ThinkingSphinx::Index.define :tvseries, :with => :active_record, delta: true do
  indexes location, comment
  indexes master_tvseries(:title), as => :name
  has agent_id, master_tvseries_id, created_at, updated_at
end