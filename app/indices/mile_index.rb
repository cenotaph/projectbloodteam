 # -*- encoding : utf-8 -*-
ThinkingSphinx::Index.define :mile, :with => :active_record, delta: true do
  indexes station, location,  comment
  has agent_id, created_at, updated_at
end