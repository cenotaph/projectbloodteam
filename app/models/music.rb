# -*- encoding : utf-8 -*-
class Music < ActiveRecord::Base
  include ItemHelpers
  belongs_to :agent
  belongs_to :currency
  has_many :userimages, :as => :entry, :dependent => :destroy
  accepts_nested_attributes_for :userimages, :allow_destroy => true, :reject_if => proc { |attributes| attributes['image'].blank?  && attributes['image_url'].blank?  && attributes['id'].blank?}
  belongs_to :master_music
  validates_presence_of :master_music_id, :agent_id, :date
  validates :date, :date => { :message => 'Invalid date' }
  has_many :entries, :as => :entry, :dependent => :delete_all
  has_many :comments, -> { where('item_type = \'MasterMusic\'')}, :foreign_key => 'foreign_id', :primary_key => 'master_music_id'

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
  
  def self.master_cols
    ["format", "label", "name"]
  end
  def icon
    if self.userimage.blank?
      self.master_music.icon
    else
      '/images/musics/' + self.id.to_s + '/thumb/' + self[:userimage]
    end
  end
  
  def master
    self.master_music
  end
  
  def master_id
    self.master_music_id
  end
  
  def metadata
    {'name' => self.master_music.linked_name, 'date' => self.date,
      'metadata' => { 
        'format' => self.master_music.format, 'label' => self.master_music.label,
        'rating' => self.rating, 'source' => self.source,  'cost' => [(self.currency_id.nil? ?  self.agent.default_currency : self.currency_id), self.cost],
        'is new' => self.isnew, 'procurement' => self.procurement
        } , 'comment' => self.comment}
  end
  
  def artist
    self.master_music.artist
  end
  
  def title
    self.master_music.title
  end
  
  def label
    self.master_music.label
  end
  
  def format
    self.master_music.format
  end
  
  def year
    self.master_music.year
  end
  
  def linked_name
    self.master_music.linked_name.gsub(/\n/, '')
  end
  
  def linkto
    self.master_music.linkto
  end
    

  def name
    self.master_music.name.gsub(/\n/, '')
  end
  
  def others
    self.master_music.musics.to_a.delete_if{|x| x == self}
  end
  
  def similars
    self.master_music.similars
  end
  
end
