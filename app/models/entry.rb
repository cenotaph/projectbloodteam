# -*- encoding : utf-8 -*-
class Entry < ActiveRecord::Base
  belongs_to :agent
  belongs_to :entry,  :polymorphic => true
  
    
end
