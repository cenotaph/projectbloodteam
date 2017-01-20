# -*- encoding : utf-8 -*-
ThinkingSphinx::Index.define :musicplayed, :with => :active_record, delta: true do
  indexes company, location, comment
  has agent_id, created_at, updated_at
end