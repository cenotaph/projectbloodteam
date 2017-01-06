# -*- encoding : utf-8 -*-
class MasterMovie < ActiveRecord::Base
  has_many :comments, -> { where('item_type = \'MasterMovie\'')}, :foreign_key => 'foreign_id', :dependent => :delete_all
  has_many :movies
  has_many :references, as: :reference
  has_many :agents, :through => :movies
  has_attached_file :filename, :default_url => '/img/no_image.png', 
      :styles => {:thumb => "150x150>", :full => "600x450>"},
      # :path => ":rails_root/public/images/master_movies/:id/:style/:basename.:extension",
      :default_style => :full, path: "/master_movies/:id/:style/:basename.:extension"
  process_in_background :filename  
  attr_accessor :followup
  include ItemHelpers
  validates_attachment_content_type :filename, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"] ,  if: :filename_file_name_changed?
  
  def resync_imdb_image
    m = Imdb::Movie.new(imdbcode)
    unless m.poster.blank?
      self.filename = URI.parse(m.poster)
      save!
    end
  end
  
  
  def self.choose(key, token = nil)
    if key =~ /^local_/
      key.gsub(/^local_/, '')
    else
      existing = self.where(:imdbcode => key)
      if existing.empty?
        m = Imdb::Movie.new(key)
        big_poster = m.poster # rescue nil
        mynew = self.new(:title => HTMLEntities.new.decode(m.title), :imdbcode => key, :director => m.director.join(', '), :country => m.countries.join(' / '), :year => m.year)
        unless big_poster.blank?
          mynew.filename = URI.parse(big_poster)
        end
        unless m.also_known_as.find{|x| x[:version] == 'World-wide (English title)' }.nil?
          mynew.english_title = HTMLEntities.new.decode  m.also_known_as.find{|x| x[:version] == 'World-wide (English title)' }[:title]
        end
        if m.also_known_as.find{|x| x[:version] == '(original title)' }.nil?
          mynew.title = HTMLEntities.new.decode m.title
          mynew.title.strip!
        else
          mynew.title = HTMLEntities.new.decode m.also_known_as.find{|x| x[:version] == '(original title)' }[:title]
        end
        mynew.save!
        mynew.id
      else
        existing.first.id
      end
    end
  end
  
  def discussion
    agg = self.movies + self.comments
    agg.sort{|x,y| x.created_at <=> y.created_at}
  end
  
  def external_index
    self.imdbcode
  end
  
  def self.grabimage(key, new_master)
    require 'open-uri'
    if key.class != IMDB
      key = IMDB.new(key)
    end
    big_poster = key.poster_link
    unless big_poster.blank?
      imdbcode = sprintf("%07d",  key.movie_name.to_i)
      new_master.filename_file_name = imdbcode  + '.jpg'
      new_master.filename_content_type = 'image/jpeg'
      system("mkdir -p " + Rails.root.to_s + '/public/images/master_movies/' + new_master.id.to_s + '/original')
      system("mkdir -p " + Rails.root.to_s + '/public/images/master_movies/' + new_master.id.to_s + '/full')
      open(Rails.root.to_s + '/public/images/master_movies/' + new_master.id.to_s + '/original/' +   imdbcode + '.jpg', "wb").write(open(key.poster_small).read)
      open(Rails.root.to_s + '/public/images/master_movies/' + new_master.id.to_s + '/full/'+   imdbcode + '.jpg', "wb").write(open(big_poster).read)
      new_master.save
    end
  end


  def icon(style = nil)
    if self.filename_file_name.blank?
        ""
    else
      self.filename.url(style)
    end
  end
  
  def items
    movies
  end

  def creator
    self.director
  end
  
  def linked_name
    if imdbcode.blank?
      self.name
    else
      out = '<a class="popup" href="http://www.imdb.com/title/tt'+ imdbcode.to_s + '"  target="_blank">' + name
      out += "</a>"
      return out
    end
  end
  
  def linkto
    "http://www.imdb.com/title/tt#{imdbcode.to_s}/"
  end
  
  def master_id
    self.id
  end
  
    
  def name
    out = "<div class='main_title'>#{title.strip}</div><div class='secondary_title'>#{secondary_title}</div>"
    out.html_safe
  end
  

  def secondary_title
    out = " ("  + [director, country, year].compact.delete_if{|x| x.blank? }.join(', ') + ")"
    out.html_safe
  end
  
  def short_name
    title
  end
  
  def icon_name
    'film'
  end
  
  def self.query(searchterm, token = nil)
    imdbhits = Imdb::Search.new(searchterm, {:ttype => :ft}).movies

  end

  def similars
    sim =  MasterMovie.where(:director => self.director).to_a.delete_if{|x| x == self}
    if self.country =~ /\//
      countries = self.country.gsub(/\n/, '').split(/\//)
    else
      countries = [self.country]
    end
    countries.each do |c|
      next if c.nil?
      sim += MasterMovie.where(:year => self.year).where(['country LIKE ?', "%#{c.strip}%"]).limit(20).to_a.delete_if{|x| x == self}
    end
    return sim.uniq
  end

  
end
