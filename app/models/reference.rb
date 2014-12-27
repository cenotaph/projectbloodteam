class Reference < ActiveRecord::Base
  belongs_to :source, polymorphic: true
  belongs_to :reference, polymorphic: true
  
  attr_accessor :activated
  
end
