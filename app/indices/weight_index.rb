 # -*- encoding : utf-8 -*-
ThinkingSphinx::Index.define :weight, :with => :active_record do
  indexes comment
  has agent_id, created_at, updated_at
end