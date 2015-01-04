class Tvseries < ActiveRecord::Base
  self.table_name = 'tvseries'

  belongs_to :master_tvseries
  belongs_to :geolocation
  include Item
  include ItemHelpers

  validates_presence_of :master_tvseries_id, :agent_id, :season
  has_many :comments, -> { where( 'item_type = \'MasterTvseries\'') }, :foreign_key => 'foreign_id', :primary_key => 'master_tvseries_id'                          


  belongs_to :geolocation
  geocoded_by :my_address
  validate :at_least_one_date
  
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
  


  
  
  def self.has_master?
    true
  end
  
  def has_master?
    true
  end
  
  def icon
    if self.userimage.blank?
      self.master_tvseries.icon
    else
      '/images/tv/' + self.id.to_s + '/thumb/' + self[:userimage]
    end
  end
  
  def at_least_one_date
    if self.finished.blank? && self.started.blank?
      self.errors.add(:base, 'You must enter at least one date.') 
      return false
    end
  end
  
  def date 
    self[:finished].blank? ? self[:started] : self[:finished]
  end
      

  def master
    self.master_tvseries
  end
  
  def self.master_cols
    ["name"]
  end
  
  def master_id
    self.master_tvseries_id
  end
  
  def metadata
    {'name' => self.master_tvseries.linked_name, 'started' => self.started, 'finished' => self.finished,
      'metadata' => { 'location' => self.location, 'season' => self.season,
        'rating' => self.rating, 
        'first' => self.first
        } , 'comment' => self.comment}
  end
  
  
  def linked_name
    self.master_tvseries.linked_name.gsub(/\n/, '')
  end
  
  def linkto
    self.master_tvseries.linkto
  end
  
  def name
    self.master_tvseries.title
  end
    
  def others
    self.master_tvseries.tvseries.to_a.delete_if{|x| x == self}
  end
  
  def similars
    self.master_tvseries.similars
  end
    
end
