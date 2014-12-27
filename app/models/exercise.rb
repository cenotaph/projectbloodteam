# -*- encoding : utf-8 -*-
class Exercise < ActiveRecord::Base
  self.table_name =  'exercise'
  belongs_to :agent
  has_many :userimages, :as => :entry, :dependent => :destroy
  accepts_nested_attributes_for :userimages, :allow_destroy => true, :reject_if => proc { |attributes| attributes['image'].blank?  && attributes['image_url'].blank?   && attributes['id'].blank?}
  has_many :entries, :as => :entry, :dependent => :delete_all
  validates_presence_of :activity, :date
  validates :date, :date => {  :message => 'Invalid date.' }
  has_many :comments, -> { where ('item_type = \'Exercise\'')}, :foreign_key => 'foreign_id', :dependent => :delete_all
  
  after_save do
    if transaction_include_any_action?([:create])
      self.add_newsfeed('created') if self.add_to_newsfeed == '1'
    elsif transaction_include_any_action?([:update])
      self.add_newsfeed('updated') if self.add_to_newsfeed == '1'
    end
  end

  def references
    []
  end
    
  include ItemHelpers
  
  def metadata
    {'name' => self.activity, 'date' => self.date,
      'metadata' => { 'hours' => self.hours, 'distance' => self.distance,
        'sets' => self.sets,  'reps' => self.reps
        } , 'comment' => self.comment}
  end
  
  def self.has_master?
    false
  end
end
