# -*- encoding : utf-8 -*-
class Eating < ActiveRecord::Base
  self.table_name =  'eating'
  belongs_to :agent
  has_many :userimages, :as => :entry, :dependent => :destroy
  accepts_nested_attributes_for :userimages, :allow_destroy => true, :reject_if => proc { |attributes| attributes['image'].blank?  && attributes['image_url'].blank?   && attributes['id'].blank?}
  has_many :entries, :as => :entry, :dependent => :delete_all
  validates_presence_of :date
  validates :date, :date => {  :message => 'Invalid date.' }
  has_many :comments, -> { where('item_type = \'Eating\'')}, :foreign_key => 'foreign_id', :dependent => :delete_all
  
  after_save do
    if transaction_include_any_action?([:create])
      self.add_newsfeed('created') if self.add_to_newsfeed == '1'
    elsif transaction_include_any_action?([:update])
      self.add_newsfeed('updated') if self.add_to_newsfeed == '1'
    end
  end
  

  
  include ItemHelpers
  
  def metadata
    { 'name' => self.date, 'date' => self.date,
      'metadata' => {'drink' => self.drink,
                     'drinkamt' => self.drinkamt,
                     'grain' => self.grain,
                     'grainamt' => self.grainamt,
                     'dairy' => self.dairy,
                     'dairyamt' => self.dairyamt,
                     'meat' => self.meat,
                     'meatamt' => self.meatamt,
                     'fruitveg' => self.fruitveg,
                     'fruitvegamt' => self.fruitvegamt,
                     'sweets' => self.sweets,
                     'sweetsamt' => self.sweetsamt,
                     'supplements' => self.supplements,
                     'supplementsamt' => self.supplementsamt,
                     'supplementsnum' => self.supplementsnum
                    }
    }
  end
  
  def name
    date
  end
  
  def self.has_master?
    false
  end
end
