# -*- encoding : utf-8 -*-
class MasterBook < ActiveRecord::Base
  has_many :comments, -> { where('item_type = \'MasterBook\'')}, :foreign_key => 'foreign_id', :dependent => :delete_all
  has_many :books
  has_many :references, as: :reference
  has_many :agents, :through => :books
  has_attached_file :filename, :default_url => '/img/no_image.png',
  :styles => {:thumb => "150x150>", :full => "600x450>"},
   :path => ":rails_root/public/images/master_books/:id/:style/:basename.:extension", 
   :default_style => :original, :url => "/images/master_books/:id/:style/:basename.:extension"
  validates_attachment_content_type :filename, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"] ,  if: :filename_file_name_changed?
  include ItemHelpers
  attr_accessor :followup, :resync_image
  # before_update :syncimage
  
  def syncimage
    return if amazoncode.blank?
    book = Amazon::Ecs.item_search(self.amazoncode, {:response_group => 'Medium'}).items[0]
    require 'open-uri'
    unless book.get_hash('LargeImage').blank?
      self.filename_file_name = self.amazoncode.to_s + '.jpg'
      system('mkdir -p ' + Rails.root.to_s + '/public/images/master_books/' + self.id.to_s + '/thumb')
      self.filename_content_type = 'image/jpeg'
      open("#{Rails.root.to_s}/public/images/master_books/#{self.id.to_s}/thumb/#{self.amazoncode}.jpg",
            "wb").write(open(book.get_hash('LargeImage')['URL']).read)
      # self.save
    end
  end

  
  def self.choose(key, token = nil)
    if key =~ /^local_/
      key.gsub(/^local_/, '')
    else
      existing = self.where(:amazoncode => key)
      if existing.empty?
        book = Amazon::Ecs.item_search(key, {:response_group => 'Medium'}).items[0]
        new_master = MasterBook.new(:amazoncode => key, :title => book.get('ItemAttributes/Title'), 
                          :author => book.get('ItemAttributes/Author'))
        require 'open-uri'
        if new_master.save
          unless book.get_hash('MediumImage').blank?
            new_master.filename_file_name = new_master.amazoncode.to_s + '.jpg'
            system('mkdir -p ' + Rails.root.to_s + '/public/images/master_books/' + new_master.id.to_s + '/original')
            new_master.filename_content_type = 'image/jpeg'
            open("#{Rails.root.to_s}/public/images/master_books/#{new_master.id.to_s}/original/#{key}.jpg","wb").write(open(book.get_hash('MediumImage')['URL']).read)
            new_master.save!
          end
          new_master.id
        end
      else
        existing.first.id
      end
    end
  end
  
  def creator
    self.author
  end
  
  def discussion
    agg = self.books + self.comments
    agg.sort{|x,y| x.created_at <=> y.created_at}
  end
  
  def external_index
    self.amazoncode
  end

  def icon(style = :original)
    if self.filename_file_name.blank?
        ""
    else
      self.filename.url(style)
    end
  end
  
  def linkto
    "http://www.amazon.com/exec/obidos/ASIN/#{self.amazoncode}?tag=problotea-20"
  end
  
  def items
    books
  end
  
  def master_id
    self.id
  end
  
  def short_name
    title
  end
  
  def icon_name
    'book'
  end
  
  def linked_name
    if amazoncode.blank?
      "#{self.title} by #{self.author}"
    else
      out = '<a class="popup" href="http://www.amazon.com/exec/obidos/ASIN/'+ self.amazoncode + '?tag=problotea-20" target="_blank">' + self.title
      out += "</a> by " + self.author  unless author.blank?
      return out
    end
  end
  
  def name
   
   "<div class='main_title'>#{title.strip}</div>" + (!self.author.nil? ? "<div class='secondary_title'>#{secondary_title}</div>" : '').html_safe

  end
  
  def secondary_title
    " <span class='small_meta'>by</span> " + self.author rescue 'no author'
  end
  
  def self.query(searchterm, token = nil)
    hits = Amazon::Ecs.item_search(searchterm, {:response_group => 'Medium'}).items
    results = []
    hits.each do |hit|
      results << {"title" => hit.get('ItemAttributes/Title').to_s + '<div class="secondary_title">' + hit.get('ItemAttributes/Author').to_s + '</div>',
                  "key" => hit.get('ASIN'), 
                  'image' => hit.get('SmallImage').nil? ? nil : hit.get('SmallImage').gsub(/\<\/url\>.*/i, '').sub(/\<url\>/i, '')
                }
    end
    results
  end

  def similars
    MasterBook.where(:author => self.author).to_a.delete_if{|x| x == self}
  end

  
end
