# -*- encoding : utf-8 -*-
require 'open-uri'

class Userimage < ActiveRecord::Base
  belongs_to :entry, :polymorphic => true
  has_attached_file :image,
    :default_url => '/img/no_image.png',
    :styles => {:thumb => "150x150>", :full => "600x450>", :fuller => "960x720>"}, 
    :path =>  ":rails_root/public/images/:entry_type/:entry_id/:mystyle:basename.:extension",
    :url => "/images/:entry_type/:entry_id/:mystyle:basename.:extension"
    
  after_save :set_original_userimage
  after_save :destroy_original
  attr_accessor :image_url
  before_validation :download_remote_image, :if => :image_url_provided?
  validates_presence_of :image_remote_url, :if => :image_url_provided?, :message => 'is invalid or inaccessible'
  validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  # validates_attachment_file_name :image, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/]
  
  def set_original_userimage
    if self.primary == true
      self.entry.userimage = self.image_file_name
      self.entry.save! rescue nil
      ActiveRecord::Base.connection.execute("delete from newsfeed where foreign_id = #{self.entry.id.to_s} order by time desc limit 1")
    end
  end


  private

  def destroy_original
    File.unlink(self.image.path)
  end
    


    def image_url_provided?
      !self.image_url.blank?
    end

    def download_remote_image
      self.image = do_download_remote_image
      self.image_remote_url = image_url
    end

    def do_download_remote_image
      io = open(URI.parse(image_url))
      def io.original_filename; base_uri.path.split('/').last; end
      io.original_filename.blank? ? nil : io
    rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
    end

end
  
