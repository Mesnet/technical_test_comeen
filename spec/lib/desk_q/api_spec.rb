# spec/lib/desk_q/api_spec.rb
require 'rails_helper'
require 'webmock/rspec'

RSpec.describe DeskQ::Api do
  let(:api) { DeskQ::Api.new }
  let(:base_url) { Rails.application.config.desk_q['base_url'] }
  let(:api_key) { Rails.application.config.desk_q['api_key'] }
  let(:sync_id) { '12345' }
  let(:attributes) { { key: 'value' } }
  let(:url) { "#{base_url}/#{sync_id}" }

  before do
    stub_request(:put, url)
      .with(
        headers: {
          'Authorization' => "Bearer #{api_key}",
          'Content-Type' => 'application/json'
        },
        body: attributes.to_json
      )
  end

  describe '#update' do
    context 'when the response is successful' do
      let(:response_body) { { success: true, data: { id: sync_id } }.to_json }

      before do
        stub_request(:put, url)
          .to_return(status: 200, body: response_body, headers: { 'Content-Type' => 'application/json' })
      end

      it 'sends a PUT request to the correct URL with the correct headers and body' do
        response = api.update(sync_id, attributes)

        expect(response).to eq(JSON.parse(response_body))
        expect(WebMock).to have_requested(:put, url)
          .with(
            headers: {
              'Authorization' => "Bearer #{api_key}",
              'Content-Type' => 'application/json'
            },
            body: attributes.to_json
          )
          .once
      end
    end

    context 'when the response is not successful' do
      before do
        stub_request(:put, url)
          .to_return(status: 500, body: 'Internal Server Error')
      end

      it 'logs an error and returns nil' do
        expect(Rails.logger).to receive(:error).with(/API request failed with status 500: Internal Server Error/)
        response = api.update(sync_id, attributes)
        expect(response).to be_nil
      end
    end

    context 'when a JSON parsing error occurs' do
      before do
        stub_request(:put, url)
          .to_return(status: 200, body: 'invalid_json')
      end

      it 'logs a JSON parsing error and returns nil' do
        expect(Rails.logger).to receive(:error).with(/Failed to parse JSON response/)
        response = api.update(sync_id, attributes)
        expect(response).to be_nil
      end
    end

    context 'when a network error occurs' do
      before do
        stub_request(:put, url).to_raise(SocketError)
      end

      it 'logs an error and returns the exception' do
        expect(Rails.logger).to receive(:error).with(/Exception occurred while making PUT request/)
        response = api.update(sync_id, attributes)
        expect(response).to be_a(SocketError)
      end
    end
  end
end
