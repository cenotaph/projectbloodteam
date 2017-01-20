 # -*- encoding : utf-8 -*-
ThinkingSphinx::Index.define :restaurant, :with => :active_record, delta: true do
  indexes name, location, company, ordered, cuisine, comment
  has agent_id, created_at, updated_at
end