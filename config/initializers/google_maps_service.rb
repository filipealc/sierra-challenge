# config/initializers/google_maps_service.rb

GoogleMapsService.configure do |config|
  config.key = ENV['GOOGLE_MAPS_API_KEY']
end
