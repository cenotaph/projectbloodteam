# -*- encoding : utf-8 -*-
class Airport < ActiveRecord::Base
  include Item
  
  validates_presence_of :name, :date
  validates :date, :date => { :message => 'Invalid date.' }
  has_many :comments, -> { where('item_type = \'Airport\'')}, :foreign_key => 'foreign_id'  , :dependent => :delete_all


  
  include ItemHelpers
  
  def metadata
    {'name' => self.name, 'date' => self.date,
      'metadata' => { 'code' => self.code, 'destination' => self.destination,
        'time_spent' => self.time_spent
        } , 'comment' => self.comment}
  end
  
  def self.has_master?
    false
  end

end
