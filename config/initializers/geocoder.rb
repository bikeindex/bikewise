if Rails.env.production?
  Geocoder.configure(
    :cache      => Redis.new,
    :lookup     => :google, 
    :use_https  => true,
    :api_key    => ENV['GOOGLE_GEOCODER'],
  )
end