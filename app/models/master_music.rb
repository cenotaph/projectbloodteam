# -*- encoding : utf-8 -*-
class MasterMusic < ActiveRecord::Base
  has_many :comments, -> { where('item_type = \'MasterMusic\'')}, :foreign_key => 'foreign_id', :dependent => :delete_all
  has_many :musics
  has_many :agents, :through => :musics
  has_attached_file :filename, :default_url => '/img/no_image.png', 
      :path => ":rails_root/public/images/master_musics/:id/:style/:basename.:extension", 
      :styles => {:thumb => "150x150", :full => "450x450>"},
      :default_style => :thumb, 
      :url => "/images/master_musics/:id/:style/:basename.:extension"
 
  include ItemHelpers
  
  attr_accessor :followup
    
  def all_versions
    (other_versions << self).map(&:musics).flatten.compact.sort_by(&:date)
  end
  
  def self.choose(key, token = nil)
  
    if key =~ /^local_/
      key.gsub(/^local_/, '')
    else
      require 'discogs'
      existing = self.where(:discogscode => key)
      if existing.empty?
        m = Discogs::Wrapper.new('Project Blood Team', token).get_release(key)
        unless m.nil?
          mynew = self.new(:title => m.title, :discogscode => key, :artist => m.artists.map(&:name).join(' / '),
                            :year => m.released, :label => m.labels.map(&:name).join(' / '), :format => m.formats.empty? ? '' : m.formats.map(&:name).join(' /'), :masterdiscogs_id => m.master_id)
          require 'open-uri'
          require 'cgi'
          
          if mynew.save
            
            unless m.images.blank?
              mynew.filename_file_name = CGI.escape(mynew.discogscode.to_s + '.jpg')
              system("mkdir -p " + Rails.root.to_s + '/public/images/master_musics/' + mynew.id.to_s + "/thumb")
               system("mkdir -p " + Rails.root.to_s + '/public/images/master_musics/' + mynew.id.to_s + "/full")

               
              open(Rails.root.to_s + '/public/images/master_musics/' + mynew.id.to_s + '/full/' + mynew.filename_file_name, "wb").write(token.get(m.images.first.uri).body) rescue nil
              open(Rails.root.to_s + '/public/images/master_musics/' + mynew.id.to_s + '/thumb/' + mynew.filename_file_name, "wb").write(token.get(m.images.first.uri150).body) rescue nil
              mynew.save!
            end
          end
          mynew.id
        end
      else
        existing.first.id
      end
    end
  end
  
  def creator
    self.artist
  end
  
  def discussion
    agg = self.musics + self.comments
    agg.sort{|x,y| x.created_at <=> y.created_at}
  end
  
  def external_index
    self.discogscode
  end

  def icon(style = :thumb)
    if self.filename_file_name.blank?
        ""
    else
      self.filename.url(style)
    end
  end
  
  def items
    musics
  end
  
  def linked_name
    if discogscode.blank?
      self.name
    else
      out = '<a class="popup" href="http://www.discogs.com/release/' + discogscode.to_s+ '"  target="_blank">' + name
      out += "</a>"
      return out
    end
  end
  
  def linkto
    "http://www.discogs.com/release/#{discogscode.to_s}"
  end
  
  def master_id
    self.id
  end
  
  
  def name
    if artist.nil? && !title.nil?
      "<div class=\"main_title\"><em>" + title + "</em></div>".html_safe
    elsif title.nil? && !artist.nil?
     "<div class=\"main_title\">" + artist + "</div>".html_safe
    else
      "<div class=\"main_title\">" + artist + " <span class='small_meta'>-</span> <em>" + title + "</em></div>".html_safe
    end
  end
  
  def short_name
    title.html_safe
  end
  
  def icon_name
    'music'
  end
  
  def master_id
    self.id
  end
  
  def other_versions
    masterdiscogs_id.nil? ? [] :  MasterMusic.where(:masterdiscogs_id => self.masterdiscogs_id).where.not(id: self.id)
  end
  
  def self.query(searchterm, token =  nil)
    return if token.nil?
    discogs = []
    logger.warn('in model method with ' + token.inspect)
    @discogs = Discogs::Wrapper.new("PBT development", token)
    logger.warn('@discogs.access token is ' + @discogs.access_token.inspect)
    @discogs.access_token = token
    logger.warn('after manually setting, @discogs.access token is ' + @discogs.access_token.inspect)
    @discogs.search(searchterm.gsub(/\s/, '%20'), :type => :release).results.each do |hit|
      next unless hit.uri =~ /\d+$/
      discogs << {"title" => hit.title, "label" => hit.label, "format" => hit.format, "summary" => hit.summary, "key" => hit.uri.match(/\d+$/)[0] }
    end
    discogs
    
  end
  
  def secondary_title
    "(" + [format, self.label, year].compact.join(', ')  + ")"
  end
  
  def similars
    sim =  MasterMusic.where(:artist => self.artist).to_a.delete_if{|x| x == self}
    unless self.label.blank?
      sim += MasterMusic.where(:label => self.label).to_a.delete_if{|x| x == self}
    end
    return sim.uniq
  end

  
end
 