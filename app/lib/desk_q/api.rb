# lib/desk_q/api.rb

require 'net/http'
require 'json'

class DeskQ::Api
  BASE_URL = Rails.application.config.desk_q['base_url']
  API_KEY = Rails.application.config.desk_q['api_key']

  def update(sync_id, attributes)
    raise ArgumentError, "Attributes must be a hash" unless attributes.is_a?(Hash)

    uri = URI("#{BASE_URL}/#{sync_id}")
    request = Net::HTTP::Put.new(uri)
    request['Authorization'] = "Bearer #{API_KEY}"
    request['Content-Type'] = 'application/json'
    request.body = attributes.to_json

    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    handle_response(response)
  rescue StandardError => e
    Rails.logger.error "Exception occurred while making PUT request to #{uri}: #{e.message}"
    e
  end

  private

  def handle_response(response)
    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body) unless response.body.empty?
    else
      Rails.logger.error "API request failed with status #{response.code}: #{response.body}"
      nil
    end
  rescue JSON::ParserError => e
    Rails.logger.error "Failed to parse JSON response: #{e.message}"
    nil
  end
end
