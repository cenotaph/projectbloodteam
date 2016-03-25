# -*- encoding : utf-8 -*-
module ItemHelpers

  attr_accessor :add_to_newsfeed, :post_to_twitter, :dont_geocode

  def add_newsfeed(action = 'created')
    Entry.create(:action => action, :agent_id => self.agent.id, :entry => self, :entry_type => self.class.to_s)
  end
  
  def agent_category
    if Agent.find(self.agent_id).categories.year(self.date.strftime('%Y')).first.nil?
      return ""
    else
      name = Agent.find(self.agent_id).categories.year(self.date.strftime('%Y')).first.send(self.class.to_s.tableize)
      if name == "0"
        self.class.to_s
      else
        name
      end
    end
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
  
  def agent_surname
   p = Profile.where(:agent_id => self.agent_id).where(:year => self.pbt_year).first
    if p.nil?
      self.agent.surname
    else
      p.surname
    end
  end
  
  def check_currency_id
    unless [Tvseries, Weight, Musicplayed, Airport].include?(self.class)
      if self.currency_id.nil? && !self.date.nil?
        self.currency_id = Profile.where(:year => self.date.strftime('%Y').to_i, :agent_id => self.agent_id).first.defaultcurrency_id
      end
    end
  end

  def constent
    comment
  end
  
    def display_cost
      if self[:cost].nil?
          self[:cost] = 0.0
      end
      if self.currency_id.nil?
        self.agent.defaultcurrency + sprintf("%0.2f", self[:cost].to_s)
      else
        self.currency.symbol + sprintf("%0.2f", self[:cost].to_s)
      end
  end
  
  def formatted_date
    if self[:date]
      df = Profile.find_by(:agent_id => self.agent_id, :year => self.date.year)
      df.nil? ? self.date.strftime('%B %d, %Y') : self.date.strftime(df.dateformat)
    elsif self.respond_to?('created_at')
      self.created_at.strftime('%B %d, %Y')
    else
      ""
    end
  end
  
  def discussion
    if self.has_master?
      agg = [self] + self.comments
      agg += self.master.send(self.class.table_name)
    else
      agg = [self]
      agg += self.comments.sort{|x,y| x.created_at <=> y.created_at}
    end
    agg.uniq
  end
  

  def column_name(col)
    View.find_by(:agent_id => agent_id, :year => date.year).agent_column_name(self, col).to_s.humanize rescue col.to_s.humanize
  end
  
  def has_master?
    false
  end
  
  def icon
    if self.userimages.empty?
       ""
    else
       self.userimages.first.image.url(:fuller)
    end
  end
  
  def my_address
    if self.respond_to?('location') 
      if self.geolocation.blank?
        self.location
      else
        self.geolocation.address
      end
    else
      self.geolocation.address
    end
  end
  
  def my_latitude
    self.geolocation.latitude
  end
  
  def my_longitude
    self.geolocation.longitude
  end
  
        
  def primary_image
    self.userimages.reject{|x| x.primary == false}.first
  end
  
  ####  change to RESTful route
  def rssurl
    'http://' + self.date.strftime("%Y") + '.bloodteam.com/restaurants/index/' + self.agent_id.to_s + '#' + self.id.to_s
  end
  
  def others
    []
  end

  
  def similars
    out = []
    case self.class.to_s
      when 'Bar'
        out += Bar.where(:name => self.name).to_a.delete_if{|x| x == self}.sort{|x, y| y.date <=> x.date }
      when 'Restaurant'
        out += Restaurant.where(:name => self.name).to_a.delete_if{|x| x == self}.sort{|x,y| y.date <=> x.date }
      when 'Event'
        out += Event.where(:name => self.name).to_a.delete_if{|x| x == self}.sort{|x,y| y.date <=> x.date }
      when 'Airport'
        out += Airport.where(:code => self.code).to_a.delete_if{|x| x==self}.sort{|x,y| y.date <=> x.date}
      else
        out = []
    end
    if self.respond_to?('geolocation') 
      if self.geolocation
        out += self.geolocation.pbt_entries
      end
    end
    return out.sort_by{|x| x.date}.delete_if{|x| x == self}.reverse.uniq
  end  

  def store_geocodes
    if self.geolocation.nil?
      if self.respond_to?('venue_address')
        self.geolocation = Geolocation.where(:address => self.venue_address).first_or_create unless self.venue_address.blank?
      else
        self.geolocation = Geolocation.where(:address => self.location).first_or_create unless self.location.blank?
      end
    end
  end
  
  def reverse_store_geocodes
    
  end
  
  def pbt_year
    if self.date.blank?
      Time.now.localtime.year
    else
      self.date.to_time.localtime.year
    end
  end
  
end
