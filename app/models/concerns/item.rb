module Item
  extend ActiveSupport::Concern
  
  included do 
    belongs_to :agent
  
    has_many :references, as: :source, :dependent => :destroy
    has_many :userimages, :as => :entry, :dependent => :destroy
    accepts_nested_attributes_for :userimages, :allow_destroy => true, :reject_if => proc { |attributes| attributes['image'].blank? && attributes['image_url'].blank?   && attributes['id'].blank?}
    belongs_to :currency
    has_many :entries, :as => :entry, :dependent => :delete_all
    
    
    before_save :check_currency_id
    #before_save :check_references
    
    after_save do
      if transaction_include_any_action?([:create])
        self.add_newsfeed('created') if self.add_to_newsfeed == '1'
      elsif transaction_include_any_action?([:update])
        self.add_newsfeed('updated') if self.add_to_newsfeed == '1'
      end
    end
  end
  
  def check_references
    potential_references = []
    begin
      Nokogiri::HTML(comment).search('i').map(&:text).uniq.each do |pr|
        movies = MasterMovie.where(MasterMovie.arel_table[:title].matches('%' + pr.strip.downcase + '%'))
        if movies.size < 5
          potential_references.push(movies).flatten!
        end
        music = MasterMusic.where(MasterMusic.arel_table[:title].matches('%' + pr.strip.downcase + '%'))
        if music.size < 15
          potential_references.push(music.first).flatten!
        end
        books = MasterBook.where(MasterBook.arel_table[:title].matches('%' + pr.strip.downcase + '%'))
        if books.size < 5
          potential_references.push(books).flatten!
        end
        tvseries = MasterTvseries.where(MasterTvseries.arel_table[:title].matches('%' + pr.strip.downcase + '%'))
        if tvseries.size < 5
          potential_references.push(tvseries).flatten!
        end
      end
        
    rescue
      nil
    end  
    return potential_references.compact
  end
  
  
end