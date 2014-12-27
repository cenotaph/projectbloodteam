# -*- encoding : utf-8 -*-
class Musicplayed < ActiveRecord::Base

  include Item
  validates_presence_of :company, :date
  validates :date, :date => {  :message => 'Invalid date.' }
  has_many :comments, -> { where('item_type = \'Musicplayed\'')}, :foreign_key => 'foreign_id', :dependent => :delete_all
  belongs_to :geolocation
  geocoded_by :my_address
  after_validation do
    store_geocodes unless self.dont_geocode == '1'
  end
  reverse_geocoded_by :my_latitude, :my_longitude
  self.table_name =  'musicplayed'
  attr_accessor :currency_id

  include ItemHelpers

  

  
  def metadata
    {'name' => self.company, 'date' => self.date,
      'metadata' => { 'location' => self.location

        } , 'comment' => self.comment}
  end
  
  def name
    self.company
  end
  
  def self.has_master?
    false
  end
end
