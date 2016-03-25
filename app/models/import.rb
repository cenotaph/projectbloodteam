class Import < ActiveRecord::Base
  belongs_to :agent
  has_many :importbacklogs, dependent: :destroy
  has_attached_file :csvfile,  :path =>  ":rails_root/public/system/imports/:agent_id/:year/:category/:basename.:extension",
    :url => "/system/imports/:agent_id/:year/:category/:basename.:extension"
  validates_attachment :csvfile, content_type: { content_type: ['text/csv']} , message: "is not in CSV format"
  
  scope :by_agent, -> (x) { where(agent_id: x)}
end
