 # -*- encoding : utf-8 -*-
ThinkingSphinx::Index.define :grocery, :with => :active_record, delta: true do
  indexes name, location,  comment
  has agent_id, created_at, updated_at
end