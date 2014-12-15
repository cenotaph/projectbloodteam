# -*- encoding : utf-8 -*-
class Activity < ActiveRecord::Base
  belongs_to :agent
  has_many :userimages, :as => :entry, :dependent => :destroy
  accepts_nested_attributes_for :userimages, :allow_destroy => true, :reject_if => proc { |attributes| attributes['image'].blank? && attributes['image_url'].blank?   && attributes['id'].blank?}
  belongs_to :currency
  has_many :entries, :as => :entry, :dependent => :delete_all
  validates_presence_of :name, :date
  validates :date, :date => {  :message => 'Invalid date.' }
  has_many :comments, -> { where('item_type = \'Activity\'')}, :foreign_key => 'foreign_id', :dependent => :delete_all
  belongs_to :geolocation
  geocoded_by :my_address
  after_validation do
    store_geocodes unless self.dont_geocode == '1'
  end
  reverse_geocoded_by :my_latitude, :my_longitude
      
  after_save do
    if transaction_include_any_action?(:create)
      self.add_newsfeed('created') if self.add_to_newsfeed == '1'
    elsif transaction_include_any_action?(:update)
      self.add_newsfeed('updated') if self.add_to_newsfeed == '1'
    end
  end
  
  
  include ItemHelpers
  
  def metadata
    {'name' => self.name, 'date' => self.date,
      'metadata' => {'cost' => [(self.currency_id.nil? ?  self.agent.default_currency : self.currency_id), self.cost], 'location' => self.location, 
                      'company' => self.company, 'rating' => self.rating
                    } , 'comment' => self.comment}
  end
  
  def self.has_master?
    false
  end
  
end
