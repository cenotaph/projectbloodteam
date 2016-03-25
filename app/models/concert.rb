# -*- encoding : utf-8 -*-
class Concert < ActiveRecord::Base
  include Item
  validates_presence_of :artists, :venue, :date
  validates :date, :date => {  :message => 'Invalid date.' }
  has_many :comments, -> { where('item_type = \'Concert\'')}, :foreign_key => 'foreign_id', :dependent => :delete_all
  belongs_to :geolocation
  geocoded_by :my_address
  after_validation do
    store_geocodes unless self.dont_geocode == '1'
  end
  reverse_geocoded_by :my_latitude, :my_longitude
  
  belongs_to :currency
  
  include ItemHelpers

  

  
  
  def name
    self.new_record? ? "" :  self.try(:artists) + "<div class=\"secondary_title\">#{secondary_title}</div>"
  end
  
  def title
    self.try(:artists)
  end
  
  def primary_title
    self.try(:artists) 
  end
  def secondary_title
    [self.try(:venue), self.date.strftime(agent.profile(date.year).dateformat)].join(' - ')
  end
  
  def metadata
    {'name' => self.artists + " (#{self.venue})", 'date' => self.date,
      'metadata' => { 'artists' => self.artists, 'venue' => self.venue,
        'company' => self.company, 'rating' => self.rating,  'cost' => [(self.currency_id.nil? ?  self.agent.default_currency : self.currency_id), self.cost]
        } , 'comment' => self.comment}
  end
  
  def self.has_master?
    false
  end
end
