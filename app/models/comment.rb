# -*- encoding : utf-8 -*-
class Comment < ActiveRecord::Base
  include Item
  has_many :entries, :as => :entry, :dependent => :destroy

  belongs_to :item, :polymorphic => true, :foreign_key => :foreign_id
  
  validate :not_empty
  validates_presence_of :foreign_id, :item_type, :agent_id
  alias_attribute :category, :item_type
  
  def check_currency_id 
    return true
  end
 attr_accessor :currency_id
      
  include ItemHelpers
  
  def self.chatter_since_last(last_login)
    sql = "select c.foreign_id, c.item_type from (	select id, foreign_id, agent_id, max(created_at) as created_at, item_type from comments WHERE created_at > '#{last_login}' GROUP BY foreign_id, item_type , id UNION select id, id as foreign_id, agent_id, created_at, 'Forum' as item_type from forums WHERE created_at > '#{last_login}' GROUP BY foreign_id, item_type, id  ) c group by c.foreign_id, c.item_type, c.created_at  ORDER by c.created_at DESC"
    find_by_sql(sql).size
  end
  
  def self.paginate_with_items(page, per_page = 20) 
    page = 1 if page.nil?
    # sql = "select c.foreign_id, c.item_type from (	select id, foreign_id, agent_id, max(created_at) as created_at, max(updated_at) as updated_at, item_type from comments group by foreign_id, item_type, id UNION select id, id as foreign_id, agent_id, created_at, updated_at, 'Forum' as item_type from forums group by foreign_id, item_type ) c group by c.foreign_id, c.item_type, c.updated_at order by c.updated_at DESC"
    sql = "select cc.foreign_id, cc.item_type, max(cc.updated_at) from (select c.foreign_id, c.item_type, c.updated_at  from (  select id, foreign_id, agent_id, max(created_at) as created_at, max(updated_at) as updated_at, item_type from comments group by foreign_id, item_type, id UNION select id, id as foreign_id, agent_id, created_at, updated_at, 'Forum' as item_type from forums group by foreign_id, item_type ) c group by c.foreign_id, c.item_type, c.updated_at order by c.updated_at DESC) cc group by cc.foreign_id, cc.item_type"
    Kaminari.paginate_array(find_by_sql(sql).to_a).page(page).per(per_page)
  end
    
    def not_empty
      if content.blank? && userimages.empty?
        self.errors.add(:base, 'Your comment cannot be blank.') 
        return false 
      end
    end
    
    def comment_path
      if item_type == 'Forum'
        "/forums/#{item.slug}"
      else
        "/#{item_type.tableize}/#{foreign_id.to_s}"
      end
    end
    
    def commentlink
      return self.item_type.tableize + '/' + self.foreign_id.to_s + '/comments'
    end
    
    def date
      self.created_at
    end
    
    def name
      # find parent and return name
     # self.category
    begin
      self.child.name
      rescue ActiveRecord::RecordNotFound
        "a deleted item"
      end
    end
    
    def childlink
      begin
        if self.item_type == 'Forum'
            [self.foreign_id]
        else
          eval(self.item_type + ".find(" + self.foreign_id.to_s + ")." + self.item_type.to_s.tableize.sub(/^master_/, '') + ".collect{|x| x.id}")
        end
      rescue ActiveRecord::RecordNotFound
        ""
      end
    end

    def child
      begin
        if self.item_type == 'Forum'
          Forum.find(foreign_id)
        else
          self.item_type.classify.constantize.find(self.foreign_id)
        end
      rescue ActiveRecord::RecordNotFound
        []
      end
    end
    
    def item
      child
    end
    
    def discussion
      child.discussion
    end
    
    def has_master?
      false
    end
    
    
    def self.has_master?
      false
    end
    
    def comment
      self.content
    end
    
    def comments
        ""
    end
      
    def discussion
     begin
        eval(self.item_type + ".find(" + self.foreign_id.to_s + ").discussion")
     rescue ActiveRecord::RecordNotFound
       []
      end
    end
    
    # def email_notify
    #    if self.category =~ /^Master/
    #      thelist = []
    #      eval("thelist = " + self.category + ".find(" + self.foreign_id.to_s + ").agents.reject{|x| x.email_notify == false }.uniq")
    #      thelist.each do |tl|
    #        Notifier.deliver_comment_notification(tl, self)
    #        #puts tl.surname
    #      end
    #    else
    #      host = eval(self.category + ".find(" + self.foreign_id.to_s + ").agent")
    #      if host.email_notify == true
    #        Notifier.deliver_comment_notification(host, self)
    #      end
    #    end
    #  end
    
    include ItemHelpers
    

    
end
