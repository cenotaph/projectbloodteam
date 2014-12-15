 # -*- encoding : utf-8 -*-
ThinkingSphinx::Index.define :eating, :with => :active_record do
  indexes drink, grain, dairy, meat, fruitveg, sweets, supplements
  has agent_id, created_at, updated_at
end