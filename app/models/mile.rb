# -*- encoding : utf-8 -*-
class Mile < ActiveRecord::Base

  include Item
  
  validates_presence_of :station, :date
  validates :date, :date => {  :message => 'Invalid date.' }
  has_many :comments, -> { where('item_type = \'Mile\'')}, :foreign_key => 'foreign_id', :dependent => :delete_all
  


  has_one :geolocation_item, as: :item
  delegate :geolocation, to: :geolocation_item, allow_nil: true
    
  include ItemHelpers
  
  belongs_to :currency

  def name
    station
  end
  
  def metadata
    {'name' => self.station, 'date' => self.date,
      'metadata' => { 'location' => self.location, 'cost' => [(self.currency_id.nil? ?  self.agent.default_currency : self.currency_id), self.cost],
        'gasamount' => self.gasamount, 'ppg' => self.ppg, 'miles' => self.miles
        } , 'comment' => self.comment}
  end
  
  def self.has_master?
    false
  end
end
