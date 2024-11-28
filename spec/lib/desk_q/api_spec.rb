# spec/lib/desk_q/api_spec.rb

require 'rails_helper'

RSpec.describe DeskQ::Api do
  let(:api) { DeskQ::Api.new }
  let(:base_url) { Rails.application.config.desk_q['base_url'] }
  let(:desk_sync_id) { 'B1F1D2' }
  let(:attributes) { { color: "RED" } }

  describe "#index" do
    it "returns a list of desks" do
      response_data = [{"id" => "41", "desk_sync_id" => "B1F1D2", "color" => "GREEN"}]

      # Mocking handle_response to simulate a successful response with desks data.
      allow(api).to receive(:handle_response).and_return(response_data)

      response = api.index
      expect(response).to be_an_instance_of(Array)
      expect(response.first["id"]).to eq("41")
      expect(response.first["color"]).to eq("GREEN")
    end
  end

  describe "#show" do
    it "returns a specific desk by desk_sync_id" do
      response_data = {"id" => "41", "desk_sync_id" => "B1F1D2", "color" => "GREEN"}

      # Mocking handle_response to simulate a successful response.
      allow(api).to receive(:handle_response).and_return(response_data)

      response = api.show(desk_sync_id)
      expect(response).to be_a(Hash)
      expect(response['desk_sync_id']).to eq("B1F1D2")
      expect(response['color']).to eq("GREEN")
    end

    it "returns nil when desk is not found (404)" do
      # Mocking handle_response to simulate a 404 Not Found response.
      allow(api).to receive(:handle_response).and_return(nil)

      response = api.show(desk_sync_id)
      expect(response).to be_nil
    end
  end

  describe "#update" do
    it "updates the color of the desk successfully" do
      response_data = {"id" => "41", "desk_sync_id" => "B1F1D2", "color" => "RED"}

      # Mocking handle_response to simulate a successful update response.
      allow(api).to receive(:handle_response).and_return(response_data)

      response = api.update(desk_sync_id, attributes)
      expect(response).to be_a(Hash)
      expect(response['color']).to eq("RED")
    end

    it "raises an error if attributes are not a hash" do
      expect { api.update(desk_sync_id, "invalid_attributes") }.to raise_error(ArgumentError, "Attributes must be a hash")
    end

    it "returns nil if the update fails due to incorrect desk_sync_id (404)" do
      # Mocking handle_response to simulate a 404 Not Found response during update.
      allow(api).to receive(:handle_response).and_return(nil)

      response = api.update(desk_sync_id, attributes)
      expect(response).to be_nil
    end
  end
end
