# -*- encoding : utf-8 -*-
class Movie < ActiveRecord::Base
  include ItemHelpers
  include Item
  

  belongs_to :master_movie


  validates_presence_of :master_movie_id, :date, :agent_id
  has_many :comments, -> { where( 'item_type = \'MasterMovie\'') }, :foreign_key => 'foreign_id', :primary_key => 'master_movie_id'                          
 
  validates :date, :date => {  :message => 'Invalid date.' }

  belongs_to :geolocation
  geocoded_by :my_address
  
  after_validation do
    store_geocodes unless self.dont_geocode == '1'
  end
  reverse_geocoded_by :my_latitude, :my_longitude
  

  

  def english_title
    master.english_title
  end
  
  
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
