 # -*- encoding : utf-8 -*-
ThinkingSphinx::Index.define :comment, :with => :active_record do
  indexes content
  has agent_id, created_at, updated_at
end