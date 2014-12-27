# -*- encoding : utf-8 -*-
class Forum < ActiveRecord::Base


  has_many :comments, ->  { where(:item_type => 'Forum')}, :foreign_key => :foreign_id, :dependent => :destroy

  extend FriendlyId
  friendly_id :subject, use: [:finders, :slugged]
  validates_presence_of :subject
  
  include Item
  
  attr_accessor :currency_id
  
  include ItemHelpers
  
  validates_presence_of :agent_id, :subject, :body
  
  def self.paginate_with_items(page, per_page = 20) 
    sql = "select * from (	select id, foreign_id, agent_id, max(created_at) as created_at, item_type from comments group by foreign_id, item_type UNION select id, id as foreign_id, agent_id, created_at, 'Forum' as item_type from forums group by foreign_id, item_type ) c group by c.foreign_id, c.item_type  order by c.created_at DESC"
    paginate_by_sql(sql, :page => page, :per_page => per_page) 
  end 
  
  def date
    self.created_at
  end
  
  def agent_icon(style = '')
    p = Profile.where(:agent_id => self.agent_id).where(:year => self.pbt_year).first
    if p.nil?
      '/img/anonymous.gif'
    else
      unless p.avatar_file_size.nil?
        if p.avatar_file_size > 0 
          p.avatar.url(style)
        else
        '/img/anonymous.gif'
        end
      else
        '/img/anonymous.gif'
      end
    end
  end
  
  
  def metadata
    {'name' => self.subject, 'date' => self.date,
      'metadata' => { } , 'comment' => self.comment}
  end
  
  def formatted_date
    self.created_at.strftime('%B %d, %Y')
  end
  
  
  def item
    self
  end
  
  def name
    self.subject
  end
  
  def content
    self.body
  end
  
  def comment
    self.body
  end
  
  def has_master?
    false
  end
  
  def title
    name
  end

  
end
