 # -*- encoding : utf-8 -*-
ThinkingSphinx::Index.define :airport, :with => :active_record, delta: true do
  indexes name, code, destination, comment
  has agent_id, created_at, updated_at
end