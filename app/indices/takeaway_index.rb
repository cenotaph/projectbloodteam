 # -*- encoding : utf-8 -*-
ThinkingSphinx::Index.define :takeaway, :with => :active_record, delta: true do
  indexes name, location, ordered, company, comment
  has agent_id, created_at, updated_at
end