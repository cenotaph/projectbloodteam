# -*- encoding : utf-8 -*-
class Videogame < ActiveRecord::Base
  belongs_to :agent
  belongs_to :master_videogame
  has_many :userimages, :as => :entry, :dependent => :destroy
  accepts_nested_attributes_for :userimages, :allow_destroy => true, :reject_if => proc { |attributes| attributes['image'].blank?  && attributes['image_url'].blank?  && attributes['id'].blank?}
  has_many :entries, :as => :entry, :dependent => :delete_all
  validate :at_least_one_date
  validates_presence_of :agent_id
  has_many :comments, -> { where('item_type = \'MasterVideogame\'')}, :foreign_key => 'foreign_id', :primary_key => :master_videogame_id


  after_save do
    if transaction_include_any_action?([:create])
      self.add_newsfeed('created') if self.add_to_newsfeed == '1'
    elsif transaction_include_any_action?([:update])
      self.add_newsfeed('updated') if self.add_to_newsfeed == '1'
    end
  end

  include ItemHelpers
  before_save :check_currency_id

  
  def at_least_one_date
    if self.finished.blank? && self.received.blank? && self.started.blank?
      self.errors.add(:base, 'You must enter at least one date.') 
      return false
    end
  end

  
  def metadata
    {'name' => self.master_videogame.linked_name, 'date' => self.date,
      'metadata' => { 'creator' => self.master_videogame.creator, 'platform' => self.master_videogame.platform,
        'rating' => self.rating, 'received' => self.received, 'started' => self.started, 'finished' => self.finished, 
        'difficulty' => self.difficulty,
        'cost' => [(self.currency_id.nil? ?  self.agent.default_currency : self.currency_id), self.cost]
        } , 'comment' => self.comment}
  end
  
  def date 
    if !self[:finished].blank?
      return self[:finished]
    else
      if self[:started].nil? 
        if self[:received].nil?
          return "2002-01-01".to_date
        else
          return self[:received]
        end
      else
        return self[:started]
      end
    end
  end
  
  
  def self.has_master?
    true
  end
  
  def has_master?
    true
  end
  
  def self.master_cols
    ["name"]
  end
  
  def icon
    if self.userimage.blank?
      self.master_videogame.icon
    else
      '/images/videogames/' + self.id.to_s + '/thumb/' + self[:userimage]
    end
  end
  
  def linked_name
    self.master_videogame.linked_name
  end
  
  def linkto
    self.master_videogame.linkto
  end
  
  def name
    self.master_videogame.name
  end
  
  def master
    self.master_videogame
  end
  

  
  def master_id
    self.master_videogame_id
  end
  
  def others
    self.master_videogame.videogames.to_a.delete_if{|x| x == self}
  end
  
  include ItemHelpers
end
