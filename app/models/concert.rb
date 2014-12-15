# -*- encoding : utf-8 -*-
class Concert < ActiveRecord::Base
  belongs_to :agent
  has_many :userimages, :as => :entry, :dependent => :destroy
  accepts_nested_attributes_for :userimages, :allow_destroy => true, :reject_if => proc { |attributes| attributes['image'].blank?  && attributes['image_url'].blank?   && attributes['id'].blank?}
  belongs_to :currency
  has_many :entries, :as => :entry, :dependent => :delete_all
  validates_presence_of :artists, :venue, :date
  validates :date, :date => {  :message => 'Invalid date.' }
  has_many :comments, -> { where('item_type = \'Concert\'')}, :foreign_key => 'foreign_id', :dependent => :delete_all
  belongs_to :geolocation
  geocoded_by :my_address
  after_validation do
    store_geocodes unless self.dont_geocode == '1'
  end
  reverse_geocoded_by :my_latitude, :my_longitude
  
  after_save do
    if transaction_include_any_action?([:create])
      self.add_newsfeed('created') if self.add_to_newsfeed == '1'
    elsif transaction_include_any_action?([:update])
      self.add_newsfeed('updated') if self.add_to_newsfeed == '1'
    end
  end
  
  include ItemHelpers
  before_save :check_currency_id
  

  
  
  def name
    self.new_record? ? "" :  self.try(:artists) + " [#{self.try(:venue)}]"
  end
  
  def title
    self.try(:artists)
  end
  
  def secondary_title
    [self.try(:venue), self.date.strftime('%d %B %Y')].join(' / ')
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
