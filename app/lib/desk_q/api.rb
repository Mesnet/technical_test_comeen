# lib/desk_q/api.rb

require 'net/http'
require 'json'

class DeskQ::Api
	BASE_URL = Rails.application.config.desk_q['base_url']
	API_KEY = Rails.application.config.desk_q['api_key']

	def initialize
		@base_url = BASE_URL
		@api_key = API_KEY
	end

	def index
		send_request(:get, @base_url)
	end

	def show(desk_sync_id)
		url = "#{@base_url}/#{desk_sync_id}"
		send_request(:get, url)
	end

	def update(desk_sync_id, attributes)
		raise ArgumentError, "Attributes must be a hash" unless attributes.is_a?(Hash)

		url = "#{@base_url}/#{desk_sync_id}"
		send_request(:put, url, attributes)
	end

	private

	def send_request(http_method, url, body = nil)
		uri = URI(url)
		request = build_request(http_method, uri, body)

		response = execute_http_request(uri, request)
		handle_response(response)
	rescue => e
		Rails.logger.error "Exception occurred while making request to #{url}: #{e.message}"
		nil
	end

	def build_request(http_method, uri, body = nil)
		request_class = case http_method
										when :get then Net::HTTP::Get
										when :put then Net::HTTP::Put
										else raise ArgumentError, "Unsupported HTTP method: #{http_method}"
										end

		request = request_class.new(uri)
		request['Authorization'] = "Bearer #{@api_key}"
		request['Content-Type'] = 'application/json'
		request.body = body.to_json if body

		request
	end

	def execute_http_request(uri, request)
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true if uri.scheme == 'https'
		http.request(request)
	end

	def handle_response(response)
		case response
		when Net::HTTPSuccess
			JSON.parse(response.body) unless response.body.empty?
		else
			Rails.logger.error "API request failed with status #{response.code}: #{response.body}"
			nil
		end
	end
end
