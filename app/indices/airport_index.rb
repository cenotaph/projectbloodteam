 # -*- encoding : utf-8 -*-
ThinkingSphinx::Index.define :airport, :with => :active_record do
  indexes name, code, destination, comment
  has agent_id, created_at, updated_at
end