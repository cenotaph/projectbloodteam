# -*- encoding : utf-8 -*-
class Geolocation < ActiveRecord::Base
  geocoded_by :address
  # reverse_geocoded_by :latitude, :longitude
  before_validation :geocode_if_blank, on: :update
  after_validation :geocode, :on => :create
  # acts_as_gmappable :process_geocoding => false
  validates_presence_of :latitude, :longitude
  has_many :activities, :dependent => :nullify 
  has_many :bars, :dependent => :nullify 
  has_many :brewing, :dependent => :nullify 
  has_many :concerts, :dependent => :nullify 
  has_many :events, :dependent => :nullify 
  has_many :gambling, :dependent => :nullify
  has_many :groceries, :dependent => :nullify 
  has_many :movies, :dependent => :nullify 
  has_many :musicplayed, :dependent => :nullify 
  has_many :restaurants, :dependent => :nullify 
  has_many :takeaways, :dependent => :nullify 
  has_many :tvseries, :dependent => :nullify 

  # after_create :update_cache
  
  def address_or_coordinates
    if self.latitude.blank? || self.longitude.blank?
      geocode
    else
      reverse_geocode
    end
  end
  
  def geocode_if_blank
    if self.latitude.blank? || self.longitude.blank?
      geocode
    end
  end
  
  def infowindow
    out = '<a href="/geolocations/' + self.id.to_s + '/edit"><i class="fa fa-globe" style="margin-right: 5px; float: left"></i></a>'
      if self.pbt_entries.size == 1
        out += "<div class=\"map_title\">#{self.pbt_entries.first.name}</div><div class=\"map_address\">#{self.address}</div><div class=\"window_entries\">entered by Agent #{self.pbt_entries.first.agent.surname}</div><div class=\"window_entries\"><a href=\"/#{self.pbt_entries.first.class.to_s.tableize}/#{(self.pbt_entries.first.id)}\">more info</a></div>"
      else
        out += "<div class=\"map_title\">#{self.address}</div><div class=\"window_entries\">#{self.pbt_entries.size.to_s} entries here!</div> <div class=\"map_marker_small\">"
        if self.pbt_entries.size > 5 
          out += "<ul>"
          self.pbt_entries.sort{|x, y| y.date <=> x.date}[0..4].each do |entry|
            out += "<li><a href=\"/#{entry.class.to_s.tableize}/#{entry.id}\">#{entry.name}</a> <a href=\"/agents/#{entry.agent.id}\">(#{entry.agent.surname})</a></li>"
          end
          out += "</ul> .. and #{self.pbt_entries.size - 5} more"
        else
          out += "<ul>"
          self.pbt_entries.sort{|x, y| y.date <=> x.date}.each do |entry|
            out += "<li><a href=\"/#{entry.class.to_s.tableize}/#{entry.id}\">#{entry.name}</a> <a href=\"/agents/#{entry.agent.id}\"> (#{entry.agent.surname})</a></li>"          
          end
          out += "</ul>"
        end
        return out + "</div>"
      end
  end

  

  def gmaps4rails_marker_picture
    {
     "width" => "20",
     "height" => "20",
     "marker_anchor" => [ 5, 10],
     "shadow_picture" => "/images/morgan.png" ,
     "shadow_width" => "110",
     "shadow_height" => "110",
     "shadow_anchor" => [ 5, 10],
    }
  end     

  def gmaps4rails_title
    if self.pbt_entries.size == 1
      "#{self.pbt_entries.first.name}"
    else
      "#{self.pbt_entries.size.to_s} entries here!"
    end
  end
  
  def pbt_entries
    out = []
    out += activities
    out += bars
    out += brewing
    out += concerts
    out += events
    out += gambling
    out += groceries
    out += movies
    out += musicplayed
    out += restaurants
    out += takeaways
    out += tvseries

    out
  end
  
  def update_cache
    File.open("#{Rails.root}/tmp/cache/pbt_world.json", 'w') do |f|
      f.puts Geolocation.all.to_gmaps4rails
    end
  end
    
end
