# -*- encoding : utf-8 -*-
class Profile < ActiveRecord::Base
  belongs_to :agent
  belongs_to :currency, :foreign_key => :defaultcurrency_id
  belongs_to :theme
  self.primary_key = 'id'
  has_attached_file :avatar, :default_url => '/images/anonymous.gif', 
                    :path => "#{Rails.root}/public/images/agents/:id/:style/:basename.:extension",
                    :url => "/images/agents/:id/:style/:basename.:extension",
                    :default_style => '',
                    :styles => { 
                      :small => "75x75#",
                      :thumb => "150x150>",
                      :large => "400x400>"
                    }
                    
  validates_presence_of :theme_id, :agent_id, :defaultcurrency_id, :surname, :missionname, :year,  :location, :age
  
  validates_attachment_size :avatar, :less_than => 2.megabytes
  validates_attachment_presence :avatar
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  
end
