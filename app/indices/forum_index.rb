 # -*- encoding : utf-8 -*-
ThinkingSphinx::Index.define :forum, :with => :active_record do
  indexes subject, body
  has agent_id, created_at, updated_at
end