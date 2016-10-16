# -*- encoding : utf-8 -*-
class Brewing < ActiveRecord::Base
  self.table_name= 'brewing'
  include Item
  

  validates_presence_of :name, :date
  validates :date,  :date => { :message => 'Invalid date.' }

  has_many :comments, -> { where('item_type = \'Brewing\'')}, :foreign_key => 'foreign_id', :dependent => :delete_all

  has_one :geolocation_item, as: :item
  delegate :geolocation, to: :geolocation_item, allow_nil: true
  geocoded_by :my_address
  after_save do
    store_geocodes unless self.dont_geocode == '1'
  end
  reverse_geocoded_by :my_latitude, :my_longitude  

  

  
  include ItemHelpers

  
  def metadata
    {'name' => "#{self.product} (#{self.task})", 'date' => self.date,
      'metadata' => { 'product' => self.product, 'task' => self.task,
        'company' => self.company, 'location' => self.location, 'cost' => [(self.currency_id.nil? ?  self.agent.default_currency : self.currency_id), self.cost]
        } , 'comment' => self.comment}
  end
  
  def name
    "#{self.product}"
  end
  
  def self.has_master?
    false
  end
  
  def title
    name
  end
  
  def secondary_title
    [self.task, self.date].compact.join(', ')
  end
end
