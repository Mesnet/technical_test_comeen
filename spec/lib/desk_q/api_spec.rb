# spec/lib/desk_q/api_spec.rb

require 'rails_helper'

RSpec.describe DeskQ::Api do
  let(:api) { DeskQ::Api.new }
  let(:sync_id) { 'B1F1D2' }
  let(:attributes) { { color: "RED" } }

  describe "#update" do
    # it "raises an error if attributes are not a hash" do
    #   expect { api.update(sync_id, "invalid_attributes") }.to raise_error(ArgumentError, "Attributes must be a hash")
    # end

    it "updates the color of the desk successfully" do
      response_data = {"id" => "41", "desk_sync_id" => "B1F1D2", "color" => "RED"}

      # Mocking handle_response to simulate a successful update response.
      allow(api).to receive(:handle_response).and_return(response_data)

      response = api.update(sync_id, attributes)
      expect(response).to be_a(Hash)
      expect(response['color']).to eq("RED")
    end

    it "returns nil if the update fails due to incorrect desk_sync_id (404)" do
      # Mocking handle_response to simulate a 404 Not Found response during update.
      allow(api).to receive(:handle_response).and_return(nil)

      response = api.update(sync_id, attributes)
      expect(response).to be_nil
    end
  end
end
