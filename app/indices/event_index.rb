 # -*- encoding : utf-8 -*-
ThinkingSphinx::Index.define :event, :with => :active_record, delta: true do
  indexes name, location, company, comment
  has agent_id, created_at, updated_at
end