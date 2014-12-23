# -*- encoding : utf-8 -*-
class Category < ActiveRecord::Base
  belongs_to :agent
  scope :year, -> (y)  { where(year: y) }
  
  
  
  def forums
    "Forum"
  end
  
end
