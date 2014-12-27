# -*- encoding : utf-8 -*-
class Weight < ActiveRecord::Base
  self.table_name =  'weight'
  include Item
  validates_presence_of :weight, :date

  has_many :comments, -> { where('item_type = \'Weight\'')}, :foreign_key => 'foreign_id', :dependent => :delete_all
  
  attr_accessor :currency_id
      
  include ItemHelpers
  
  def metadata
    {'name' => self.weight, 'date' => self.date,
      'metadata' => {  
        } , 'comment' => self.comment}
  end
  
  def name
    self.date.to_s
  end
  
  def self.has_master?
    false
  end
end
