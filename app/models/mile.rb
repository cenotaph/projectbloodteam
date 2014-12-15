# -*- encoding : utf-8 -*-
class Mile < ActiveRecord::Base
  belongs_to :agent
  has_many :userimages, :as => :entry, :dependent => :destroy
  accepts_nested_attributes_for :userimages, :allow_destroy => true, :reject_if => proc { |attributes| attributes['image'].blank?  && attributes['image_url'].blank? && attributes['id'].blank? }
  has_many :entries, :as => :entry, :dependent => :delete_all
  validates_presence_of :station, :date
  validates :date, :date => {  :message => 'Invalid date.' }
  has_many :comments, -> { where('item_type = \'Mile\'')}, :foreign_key => 'foreign_id', :dependent => :delete_all
  
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
