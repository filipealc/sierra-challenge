# app/services/distance_calculator_service.rb
require 'google_maps_service'

class DistanceCalculatorService
  def self.calculate_distance(origin:, destination:)
    gmaps = GoogleMapsService::Client.new(key: ENV['GOOGLE_MAPS_API_KEY'])

    begin
      results = gmaps.directions(origin, destination, mode: 'driving')

      # Check if the results array has at least one route and the route has legs.
      if results.any? && results[0].key?(:legs) && results[0][:legs].any?
        return results[0][:legs][0][:distance][:text]
      else
        # Log an error message if the expected data isn't present
        Rails.logger.error("No distance data available for the given origin and destination.")
      end
    rescue GoogleMapsService::Error => e
      # Log the error message from the exception
      Rails.logger.error("Distance calculation failed: #{e.message}")
    end

    # Return nil if the result is not as expected or an error occurs
    nil
  end
end
