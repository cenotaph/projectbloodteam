# -*- encoding : utf-8 -*-
class Gambling < ActiveRecord::Base
  self.table_name = 'gambling'
  include Item
  
  validates_presence_of :name, :date
  validates :date, :date => {  :message => 'Invalid date.' }
  has_many :comments, -> { where('item_type = \'Gambling\'')}, :foreign_key => 'foreign_id', :dependent => :delete_all

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
      'metadata' => { 'location' => self.location, 'games' => self.games,
        'profit' => [(self.currency_id.nil? ?  self.agent.default_currency : self.currency_id), self.profit], 'rating' => self.rating
        } , 'comment' => self.comment}
  end
  
  def cost
    profit
  end
  
  def self.has_master?
    false
  end
end
