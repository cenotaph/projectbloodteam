class MasterTvseries < ActiveRecord::Base
  has_many :comments, -> { where('item_type = \'MasterTvseries\'')}, :foreign_key => 'foreign_id', :dependent => :delete_all
  has_many :tvseries
   has_many :references, as: :reference
  has_many :agents, :through => :tvseries
  has_attached_file :image, :default_url => '/img/no_image.png',
      :styles => {:thumb => "150x150>", :full => "600x450>"},
      # :path => ":rails_root/public/images/master_tvseries/:id/:style/:basename.:extension",
      :default_style => :full, path: "/master_tvseries/:id/:style/:basename.:extension"

  attr_accessor :followup, :resync_image
  include ItemHelpers
  extend FriendlyId
  friendly_id :title_and_year, use: [:slugged, :finders]
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"] ,  if: :image_file_name_changed?

  def title_and_year
    "#{title}-#{year}"
  end

  def filename
    image
  end

  def filename?
    image?
  end

  def self.choose(key, token = nil)

    if key =~ /^local_/
      key.gsub(/^local_/, '')
    else
      existing = self.where(:imdbcode => key)

      if existing.empty?

        m = OMDB.id("tt#{sprintf("%07d", key)}")
        big_poster = m.poster # rescue nil
        mynew = self.new(:title => m.title.gsub(/^\"/, '').gsub(/\"$/, '').strip, :year => m.year, :imdbcode => key)
        require 'open-uri'
        if mynew.save

          unless big_poster.blank? || big_poster == 'N/A'
            mynew.image = URI.parse(big_poster.gsub(/X300\.jpg/, '.jpg'))
          end
            # imdbcode = sprintf("%07d",  key.to_i)
            # mynew.image_file_name = imdbcode  + '.jpg'
            # mynew.image_content_type = 'image/jpeg'
            # system("mkdir -p " + Rails.root.to_s + '/public/images/master_tvseries/' + mynew.id.to_s + '/thumb')
            # system("mkdir -p " + Rails.root.to_s + '/public/images/master_tvseries/' + mynew.id.to_s + '/full')
            # open(Rails.root.to_s + '/public/images/master_tvseries/' + mynew.id.to_s + '/thumb/' +   imdbcode + '.jpg', "wb").write(open(m.poster).read) unless m.poster.blank?
            # open(Rails.root.to_s + '/public/images/master_tvseries/' + mynew.id.to_s + '/full/' +   imdbcode + '.jpg', "wb").write(open(big_poster).read)
            # mynew.save!
          # end
          mynew.id
        end
      else

        existing.first.id
      end
    end
  end

  def discussion
    agg = self.tvseries + self.comments
    agg.sort{|x,y| x.created_at <=> y.created_at}
  end

  def external_index
    self.imdbcode
  end

  def short_name
    title
  end
  def icon_name
    'image'
  end

  def self.grabimage(key, new_master)
    require 'open-uri'
    if key.class != OMDB
      key = OMDB.id("tt#{sprintf("%07d", key)}")
    end
    big_poster = key.poster
    unless big_poster.blank? || big_poster == 'N/A'
      imdbcode = sprintf("%07d",  key.movie_name.to_i)
      new_master.filename_file_name = imdbcode  + '.jpg'
      new_master.filename_content_type = 'image/jpeg'
      system("mkdir -p " + Rails.root.to_s + '/public/images/master_tvseries/' + new_master.id.to_s + '/original')
      system("mkdir -p " + Rails.root.to_s + '/public/images/master_tvseries/' + new_master.id.to_s + '/full')
      open(Rails.root.to_s + '/public/images/master_tvseries/' + new_master.id.to_s + '/original/' +   imdbcode + '.jpg', "wb").write(open(key.poster.gsub(/X300\.jpg/, '.jpg')).read)
      open(Rails.root.to_s + '/public/images/master_tvseries/' + new_master.id.to_s + '/full/'+   imdbcode + '.jpg', "wb").write(open(big_poster).read)
      new_master.save
    end
  end




  def icon(style = nil)
    if self.image_file_name.blank?
        ""
    else
      self.image.url(style)
    end
  end

  def items
    tvseries
  end

  def creator
    self.director
  end

  def linked_name
    if imdbcode.blank?
      self.title
    else
      out = '<a class="popup" href="http://www.imdb.com/title/tt'+ sprintf('%07d', imdbcode).to_s + '"  target="_blank">' + title
      out += "</a>"
      return out
    end
  end

  def linkto
    "http://www.imdb.com/title/tt#{sprintf('%07d', imdbcode).to_s}/"
  end

  def master_id
    self.id
  end


  def name
    out = "<div class='main_title'>#{title.strip}</div>"

    out.html_safe
  end


  def secondary_title
    out = " (#{year})"
    out.html_safe
  end

  def self.query(searchterm, token = nil)
    imdbhits = OMDB.search(searchterm)
    if imdbhits.class == Hash
      if imdbhits.has_key?(:error)
        return imdbhits[:error]
      else
        return [imdbhits]
      end
    else
      return imdbhits
    end

  end

  def similars
    []
  end

end
