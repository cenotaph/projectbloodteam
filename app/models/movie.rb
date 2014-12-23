# -*- encoding : utf-8 -*-
class Movie < ActiveRecord::Base
  include ItemHelpers
  belongs_to :agent
  belongs_to :master_movie
  belongs_to :currency
  has_many :userimages, :as => :entry, :dependent => :destroy
  accepts_nested_attributes_for :userimages, :allow_destroy => true, :reject_if => proc { |attributes| attributes['image'].blank?  && attributes['image_url'].blank?  && attributes['id'].blank?}
  validates_presence_of :master_movie_id, :date, :agent_id
  has_many :comments, -> { where( 'item_type = \'MasterMovie\'') }, :foreign_key => 'foreign_id', :primary_key => 'master_movie_id'                          
  has_many :entries, :as => :entry, :dependent => :delete_all
  validates :date, :date => {  :message => 'Invalid date.' }

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

  
  
  def self.has_master?
    true
  end
  
  def has_master?
    true
  end
  
  def icon
    if self.userimage.blank?
      self.master_movie.icon
    else
      '/images/movies/' + self.id.to_s + '/thumb/' + self[:userimage]
    end
  end
  
  def master
    self.master_movie
  end
  
  def self.master_cols
    ["name"]
  end
  
  def master_id
    self.master_movie_id
  end
  
  def metadata
    {'name' => self.master_movie.linked_name, 'date' => self.date,
      'metadata' => { 'location' => self.location, 'company' => self.company, 'format' => self.format,
        'rating' => self.rating, 'started' => self.started,  'cost' => [(self.currency_id.nil? ?  self.agent.default_currency : self.currency_id), self.cost],
        'first' => self.first
        } , 'comment' => self.comment}
  end
  
  
  def linked_name
    self.master_movie.linked_name.gsub(/\n/, '')
  end
  
  def linkto
    self.master_movie.linkto
  end
  
  def name
    self.master_movie.name
  end
    
  def others
    self.master_movie.movies.to_a.delete_if{|x| x == self}
  end
  
  def similars
    self.master_movie.similars
  end
  
end
