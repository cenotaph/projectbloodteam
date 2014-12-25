# -*- encoding : utf-8 -*-
class MasterVideogame < ActiveRecord::Base
  has_many :comments, -> { where('item_type = \'MasterVideogame\'')}, :foreign_key => 'foreign_id', :dependent => :delete_all
  has_many :videogames
  has_many :agents, :through => :videogames
  has_attached_file :filename, :default_url => '/img/no_image.png', 
  :path => ":rails_root/public/images/master_videogames/:id/:style/:basename.:extension", 
  :styles => {:thumb => "150x150", :full => "450x450>"},
      :default_style => :thumb, 
       :url => "/images/master_videogames/:id/:style/:basename.:extension"
 
  include ItemHelpers
  attr_accessor :followup
  
  def self.choose(key, token = nil)
    if key =~ /^local_/
      key.gsub(/^local_/, '')
    else
      existing = self.where(:amazoncode => key)
      if existing.empty?
        videogame = Amazon::Ecs.item_search(key, :search_index => 'VideoGames', :response_group => 'Medium').items[0]
        new_master = MasterVideogame.new(:amazoncode => key, :title => videogame.get('ItemAttributes/Title'), :creator => videogame.get('ItemAttributes/Author'))
        require 'open-uri'
        if new_master.save
          unless videogame.get_hash('mediumimage').blank?
            new_master.filename_file_name = new_master.amazoncode.to_s + '.jpg'
            system('mkdir -p ' + Rails.root.to_s + '/public/images/master_videogames/' + new_master.id.to_s + '/thumb')
            new_master.filename_content_type = 'image/jpeg'
            open(Rails.root.to_s+'/public/images/master_videogames/' + new_master.id.to_s + '/thumb' +  amazoncode + '.jpg', "wb").write(open(videogame.get_hash('mediumimage')[:url]).read)
            new_master.save!
          end
          new_master.id
        end
      else
        existing.first.id
      end
    end
  end
  
  def discussion
    agg = self.videogames + self.comments
    agg.sort{|x,y| x.created_at <=> y.created_at}
  end
  
  def external_index
    self.amazoncode
  end
  

  def icon(style = :thumb)
    if self.filename_file_name.blank?
        ""
    else
      self.filename.url(style)
    end
  end
  
  def items
    videogames
  end
  
  def linked_name
    if amazoncode.blank?
      "#{self.title} by #{self.creator}"
    else
      out = '<a class="popup" href="http://www.amazon.com/exec/obidos/ASIN/'+ self.amazoncode + '?tag=problotea-20" target="_blank">' + self.title
      out += "</a>"
      unless self.creator.blank?
        out += " by " + self.creator
      end
      return out
    end
  end
  
  def linkto
    "http://www.amazon.com/exec/obidos/ASIN/#{self.amazoncode}?tag=problotea-20"
  end
  
  def master_id
    self.id
  end
  
  
  def name
      if self.creator.blank?
        self.title
      else
        self.title + " by " + self.creator
      end
  end
  def icon_name
    'gamepad'
  end
  def short_name
    title
  end
  
  def secondary_title
    ''
  end
  
  def self.query(searchterm, token = nil)
    hits = Amazon::Ecs.item_search(searchterm, :response_group => 'Medium', :search_index => 'VideoGames').items
    results = []
    hits.each do |hit|
      results << {"title" => hit.get('ItemAttributes/Title').to_s, "key" => hit.get('ASIN'), 'image' => hit.get('SmallImage').nil? ? nil : hit.get('SmallImage').gsub(/\<\/url\>.*/i, '').sub(/\<url\>/i, '') }
    end
    results.delete_if{|x| x['key'].nil? }

  end

  def similars
    MasterVideogame.where(:creator => self.creator).where.not(id: self.id)
  end

  
end
