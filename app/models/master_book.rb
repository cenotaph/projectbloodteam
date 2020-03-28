# -*- encoding : utf-8 -*-
class MasterBook < ActiveRecord::Base
  has_many :comments, -> { where('item_type = \'MasterBook\'')}, :foreign_key => 'foreign_id', :dependent => :delete_all
  has_many :books
  has_many :references, as: :reference
  has_many :agents, :through => :books
  has_attached_file :filename, :default_url => '/img/no_image.png',
  :styles => {:thumb => "150x150>", :full => "600x450>"},
   # :path => ":rails_root/public/images/master_books/:id/:style/:basename.:extension",
   #:default_style => :original,
    path: "/master_books/:id/:style/:basename.:extension"
  validates_attachment_content_type :filename, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"] ,  if: :filename_file_name_changed?
  include ItemHelpers
  attr_accessor :followup, :resync_image
  #before_create :syncimage

  def syncimage
    return if amazoncode.blank?
    book = Amazon::Ecs.item_search(self.amazoncode, search_index: 'Books', IdType: 'ISBN', :response_group => 'Medium').items[0]
    require 'open-uri'
    unless book.get_hash('LargeImage').blank?
      self.filename = URI.parse(book.get_hash('LargeImage')['URL'])
      self.save
    end
  end


  def self.choose(key, token = nil)
    if key =~ /^local_/
      key.gsub(/^local_/, '')
    else
      existing = self.where(["amazoncode =? OR open_library=  ?", key, key])
      if existing.empty?
        client = Openlibrary::Client.new
        data = Openlibrary::Data
        book = data.find_by_olid(key)
        if book.nil?
          return nil
        else
          new_master = MasterBook.new(amazoncode: nil, open_library: key, title: book.title,
            author: book&.authors&.map(&:name)&.join(', ').to_s)
          # book = Amazon::Ecs.item_search(key, search_index: 'Books', IdType: 'ISBN', :response_group => 'Medium').items[0]

          # new_master = MasterBook.new(:amazoncode => key, :title => book.get('ItemAttributes/Title'),
          # :author => book.get('ItemAttributes/Author'))
          require 'open-uri'
          unless book&.cover&.large.nil?
            new_master.filename = URI.parse(book.cover.large)
          end
          if new_master.save
            new_master.id
          end
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
    if amazoncode && open_library
      ["https://www.amazon.com/exec/obidos/ASIN/#{self.amazoncode}?tag=#{ENV['AMAZON_ASSOC']}", "https://openlibrary.org/books/#{self.open_library}"]
    elsif amazoncode
      ["https://www.amazon.com/exec/obidos/ASIN/#{self.amazoncode}?tag=#{ENV['AMAZON_ASSOC']}"]
    elsif open_library
      ["https://openlibrary.org/books/#{self.open_library}"]
    else
      []
    end
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
    client = Openlibrary::Client.new
    data = Openlibrary::Data
    hits = client.search({q: searchterm, mode: 'everything'}, 250)
    # hits = Amazon::Ecs.item_search(searchterm, {:response_group => 'Medium'}).items
    results = []
    hits.each do |hit|
      next if hit.edition_key.nil?
      this_isbn = data.find_by_olid(hit.edition_key.first)

      results << { "title" => this_isbn.title  + '<div class="secondary_title">' + this_isbn&.authors&.map{|x| x['name']}&.join(', ').to_s + "</div>",
        "key" => this_isbn.identifiers.openlibrary,
        "image": this_isbn&.cover&.medium }

      # results << {"title" => hit.get('ItemAttributes/Title').to_s + '<div class="secondary_title">' + hit.get('ItemAttributes/Author').to_s + '</div>',
      #             "key" => hit.get('ASIN'),
      #             'image' => hit.get('SmallImage').nil? ? nil : hit.get('SmallImage').gsub(/\<\/url\>.*/i, '').sub(/\<url\>/i, '')
      #           }
      # end
    end
    results
  end

  def similars
    MasterBook.where(:author => self.author).to_a.delete_if{|x| x == self}
  end


end
