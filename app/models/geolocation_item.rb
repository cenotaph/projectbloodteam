class GeolocationItem < ApplicationRecord
  belongs_to :geolocation
  belongs_to :item, polymorphic: true
end
