# config/initializers/geocoder.rb

# geocoding service (see below for supported options):
Geocoder::Configuration.lookup = :google

# to use an API key:
#Geocoder::Configuration.api_key = "ABQIAAAAlvIkRb3EDPXRSGBV8HtzgxTf7jhk7eRk5Oe8esjWawVh0BjKQRQQ9voArjz5lCrm7qM66zehgk9DUw"
#Geocoder::Configuration.api_key = 'w090.com': 'ABQIAAAAlvIkRb3EDPXRSGBV8HtzgxTf7jhk7eRk5Oe8esjWawVh0BjKQRQQ9voArjz5lCrm7qM66zehgk9DUw'

# geocoding service request timeout, in seconds (default 3):
Geocoder::Configuration.timeout = 5

# use HTTPS for geocoding service connections:
Geocoder::Configuration.use_https = false

# language to use (for search queries and reverse geocoding):
Geocoder::Configuration.language = "zh-CN"

# use a proxy to access the service:
#Geocoder::Configuration.http_proxy  = "127.4.4.1"
#Geocoder::Configuration.https_proxy = "127.4.4.2" # only if HTTPS is needed

# caching (see below for details)
Geocoder::Configuration.cache = Redis.new
Geocoder::Configuration.cache_prefix = "geo"