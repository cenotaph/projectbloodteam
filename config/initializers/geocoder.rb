Geocoder.configure(

  # geocoding service (see below for supported options):
  :lookup => :nominatim
)

Geocoder.configure(http_headers: { "User-Agent" => ENV['contact_email'] })
