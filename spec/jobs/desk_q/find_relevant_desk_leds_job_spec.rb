# spec/jobs/desk_q/find_relevant_desk_leds_job_spec.rb
require 'rails_helper'

RSpec.describe DeskQ::FindRelevantDeskLedsJob, type: :job do
  describe '#perform' do
    let(:desk_1) { create(:desk, sync_id: '1_ABC') }
    let(:desk_2) { create(:desk, sync_id: '2_ABC') }

    before do
      allow(DeskQ::UpdateDeskLedJob).to receive(:perform_now)
    end

    context 'when bookings are starting soon' do
      let!(:booked_starting_soon) { create(:desk_booking, desk: desk_1, start_datetime: 10.minutes.from_now, end_datetime: 1.hour.from_now, state: 'booked') }
      let!(:checked_in_starting_soon) { create(:desk_booking, desk: desk_2, start_datetime: 5.minutes.from_now, end_datetime: 2.hours.from_now, state: 'checked_in') }

      it 'updates LED color to RED for starting soon bookings' do
        described_class.perform_now

        expect(DeskQ::UpdateDeskLedJob).to have_received(:perform_now).with(booked_starting_soon.desk.sync_id, 'RED')
        expect(DeskQ::UpdateDeskLedJob).to have_received(:perform_now).with(checked_in_starting_soon.desk.sync_id, 'RED')
      end
    end

    context 'when bookings are ending soon' do
      let!(:booked_ending_soon) { create(:desk_booking, desk: desk_1, start_datetime: 1.hour.ago, end_datetime: 10.minutes.from_now, state: 'booked') }
      let!(:checked_in_ending_soon) { create(:desk_booking, desk: desk_2, start_datetime: 2.hours.ago, end_datetime: 5.minutes.from_now, state: 'checked_in') }

      it 'updates LED color to GREEN for ending soon bookings' do
        described_class.perform_now

        expect(DeskQ::UpdateDeskLedJob).to have_received(:perform_now).with(booked_ending_soon.desk.sync_id, 'GREEN')
        expect(DeskQ::UpdateDeskLedJob).to have_received(:perform_now).with(checked_in_ending_soon.desk.sync_id, 'GREEN')
      end
    end

    context 'when bookings are not relevant' do
      let!(:checked_out_booking) { create(:desk_booking, desk: desk_1, start_datetime: 2.hours.ago, end_datetime: 1.hour.ago, state: 'checked_out') }
      let!(:canceled_booking) { create(:desk_booking, desk: desk_2, start_datetime: 20.minutes.from_now, end_datetime: 1.hour.from_now, state: 'canceled') }

      it 'does not update LED color for non-relevant bookings' do
        described_class.perform_now

        expect(DeskQ::UpdateDeskLedJob).not_to have_received(:perform_now).with(checked_out_booking.desk.sync_id, anything)
        expect(DeskQ::UpdateDeskLedJob).not_to have_received(:perform_now).with(canceled_booking.desk.sync_id, anything)
      end
    end

    context 'when an error occurs during processing' do
      before do
        allow(DeskBooking).to receive(:starting_soon).and_raise(StandardError, 'Unexpected error')
        allow(Rails.logger).to receive(:error)
      end

      it 'logs an error message' do
        described_class.perform_now

        expect(Rails.logger).to have_received(:error).with(/Failed to process LED updates for relevant desk bookings: Unexpected error/)
      end
    end
  end
end
