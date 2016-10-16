# -*- encoding : utf-8 -*-
class Takeaway < ActiveRecord::Base
  self.table_name =  'takeaway'
  include Item
  
  validates_presence_of :name, :date
  validates :date, :date => {  :message => 'Invalid date.' }
  has_many :comments, -> { where( 'item_type = \'Takeaway\'')}, :foreign_key => 'foreign_id', :dependent => :delete_all

  has_one :geolocation_item, as: :item
  delegate :geolocation, to: :geolocation_item, allow_nil: true
  geocoded_by :my_address
  after_save do
    store_geocodes unless self.dont_geocode == '1'
  end
  reverse_geocoded_by :my_latitude, :my_longitude
    

  
  include ItemHelpers

  def metadata
    {'name' => self.name, 'date' => self.date,
      'metadata' => { 'location' => self.location, 'company' => self.company,
        'rating' => self.rating, 'ordered' => self.ordered,  'cost' => [(self.currency_id.nil? ?  self.agent.default_currency : self.currency_id), self.cost]
        } , 'comment' => self.comment}
  end
  
  def self.has_master?
    false
  end
  
  def title
    name
  end
  
  def secondary_title
    location
  end
end
