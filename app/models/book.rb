# -*- encoding : utf-8 -*-
class Book < ActiveRecord::Base
  belongs_to :agent
  belongs_to :master_book
  has_many :userimages, :as => :entry, :dependent => :destroy
  accepts_nested_attributes_for :userimages, :allow_destroy => true, :reject_if => proc { |attributes| attributes['image'].blank?  && attributes['image_url'].blank?   && attributes['id'].blank?}
  has_many :entries, :as => :entry, :dependent => :delete_all
  validates_presence_of :agent_id, :currency_id
  validate :at_least_one_date

  has_many :comments, -> { where('item_type = \'MasterBook\'')}, :foreign_key => 'foreign_id', :primary_key => 'master_book_id'
  after_save do
    if transaction_include_any_action?([:create])
      self.add_newsfeed('created') if self.add_to_newsfeed == '1'
    elsif transaction_include_any_action?([:update])
      self.add_newsfeed('updated') if self.add_to_newsfeed == '1'
    end
  end
  
  include ItemHelpers
  
  
  def self.yearly(year = Time.now.strftime('%Y'))
    where("(received >= '#{year}-01-01' AND received <= '#{year}-12-31') OR (started >= '#{year}-01-01' AND started <= '#{year}-12-31') OR (finished >= '#{year}-01-01' AND finished <= '#{year}-12-31')")
  end
  
  def at_least_one_date
    if self.finished.blank? && self.received.blank? && self.started.blank?
      self.errors.add(:base, 'You must enter at least one date.') 
      return false
    end
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
  
  
  def icon
    if self.userimages.empty?
      self.master_book.icon
    else
      self.userimages.first.image.url(:thumb)
    end
  end
  
  def master
    self.master_book
  end
  
  def self.master_cols
    ["name"]
  end
  
  def author
    self.master_book.author
  end
  
  def title
    self.master_book.title
  end
  
  def master_id
    self.master_book_id
  end
  
  def metadata
    {'name' => self.master_book.linked_name, 'date' => [self.received, self.started, self.finished],
      'metadata' => { 'received on' => self.received, 'started on' => self.started, 'finished on' => self.finished, 'time taken to read' =>
         (self.finished.blank? ? nil : 
                                        (self.started.blank? ? "" : 
                                                                    ((self.finished - self.started).to_i + 1).to_s + ' day' + (
                                                                    ( (self.finished - self.started).to_i > 0 ) ? 's' : '') )),
         'difficulty' => self.difficulty, 'pagecount' => self.pagecount,
        'rating' => self.rating, 'source' => self.source,  'cost' => [(self.currency_id.nil? ?  self.agent.default_currency : self.currency_id), self.cost],
        'first reading?' => self.first
        } , 'comment' => self.comment}
  end
  
  
  def linked_name
    self.master_book.linked_name.gsub(/\n/, '')
  end
  
  def name
    self.master_book.name.gsub(/\n/, '')
  end
  
  def linkto
    self.master_book.linkto
  end
  def others
    self.master_book.books.delete_if{|x| x == self}
  end
  
  def similars
    self.master_book.similars
  end
  
  
end
