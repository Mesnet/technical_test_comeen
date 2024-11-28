require 'rails_helper'

RSpec.describe DeskQ::UpdateDeskLedJob, type: :job do
  let(:desk) { create(:desk, sync_id: '12345') }
  let(:user) { create(:user, time_zone: 'UTC') }
  let(:desk_booking) { create(:desk_booking, desk: desk, user: user) }

  describe '#perform' do
    context 'when desk_booking exists and desk_sync_id is valid' do
      it 'updates the LED color' do
        # Mock the API call
        api_instance = instance_double("DeskQ::Api")
        allow(DeskQ::Api).to receive(:new).and_return(api_instance)
        expect(api_instance).to receive(:update).with('12345', { color: 'RED' }).and_return(true)

        # Perform the job
        described_class.perform_now(desk.sync_id, 'RED')
      end
    end

    context 'when an exception occurs during the API call' do
      it 'logs the error' do
        # Mock the API call to raise an exception
        api_instance = instance_double("DeskQ::Api")
        allow(DeskQ::Api).to receive(:new).and_return(api_instance)
        allow(api_instance).to receive(:update).and_raise(StandardError, "Test exception")

        # Expect a log error
        expect(Rails.logger).to receive(:error).with("UpdateDeskLedJob: Failed to update LED for DeskSyncId #{desk.sync_id} with error: Test exception")

        # Perform the job
        described_class.perform_now(desk.sync_id, 'RED')
      end
    end
  end
end
