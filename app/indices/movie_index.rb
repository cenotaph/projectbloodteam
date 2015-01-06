 # -*- encoding : utf-8 -*-
ThinkingSphinx::Index.define :movie, :with => :active_record do
  indexes location, company, comment
  indexes master_movie(:title), as => :name
  indexes master_movie(:english_title), as => :english_title
  indexes master_movie(:director), as => :director
  has agent_id, master_movie_id, created_at, updated_at
end