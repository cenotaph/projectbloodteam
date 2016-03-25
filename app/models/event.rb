# -*- encoding : utf-8 -*-
class Event < ActiveRecord::Base

  validates_presence_of :name, :date
  validates :date, :date => {  :message => 'Invalid date.' }

  belongs_to :geolocation
  geocoded_by :my_address
  after_validation do
    store_geocodes unless self.dont_geocode == '1'
  end
  
  reverse_geocoded_by :my_latitude, :my_longitude
  has_many :comments, -> { where('item_type = \'Event\'')}, :foreign_key => 'foreign_id', :dependent => :destroy
  belongs_to :currency
  
  include Item
  
  include ItemHelpers


    
  def metadata
    {'name' => self.name, 'date' => self.date,
      'metadata' => { 'location' => self.location + (self.venue_address.blank? ? '' : ", " + self.venue_address), 'company' => self.company,
        'rating' => self.rating,  'cost' => [(self.currency_id.nil? ?  self.agent.default_currency : self.currency_id), self.cost]
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
