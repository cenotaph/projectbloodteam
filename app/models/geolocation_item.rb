class GeolocationItem < ApplicationRecord
  belongs_to :geolocation
  belongs_to :item, polymorphic: true
  validates_presence_of :geolocation_id, :item_id
end
