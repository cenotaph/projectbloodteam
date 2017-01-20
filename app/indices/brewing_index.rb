 # -*- encoding : utf-8 -*-
ThinkingSphinx::Index.define :brewing, :with => :active_record, delta: true do
  indexes product, task, location, company, comment
  has agent_id, created_at, updated_at
end