class Reference < ActiveRecord::Base
  belongs_to :source, polymorphic: true
  belongs_to :reference, polymorphic: true
  
  attr_accessor :activated
  validates_presence_of :source_id, :reference_id
end
