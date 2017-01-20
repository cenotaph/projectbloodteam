 # -*- encoding : utf-8 -*-
ThinkingSphinx::Index.define :concert, :with => :active_record, delta: true do
  indexes artists, venue,  company, comment
  has agent_id, created_at, updated_at
end