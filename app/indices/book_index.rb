 # -*- encoding : utf-8 -*-
ThinkingSphinx::Index.define :book, :with => :active_record do
  indexes source, comment
  indexes master_book(:author), :as => :author
  indexes master_book(:title), :as => :title
  has agent_id, master_book_id, created_at, updated_at
end