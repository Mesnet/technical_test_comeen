# spec/services/desk_q/led_manager_spec.rb
require 'rails_helper'

RSpec.describe DeskQ::LedManager do
  let(:user) { create(:user) }
  let(:desk) { create(:desk) }
  let(:desk_booking) { create(:desk_booking, desk: desk, user: user, state: initial_state, start_datetime: start_datetime, end_datetime: end_datetime) }
  let(:led_manager) { DeskQ::LedManager.new(desk_booking) }

  let(:start_datetime) { 1.hour.ago }
  let(:end_datetime) { 1.hour.from_now }

  before do
    allow(DeskQ::UpdateDeskLedJob).to receive(:perform_now)
  end

  describe '#perform!' do
    context 'when the desk booking is active and checked in' do
      let(:initial_state) { 'checked_in' }

      it 'triggers UpdateDeskLedJob with RED color' do
        allow(desk_booking).to receive(:active?).and_return(true)
        led_manager.perform!
        expect(DeskQ::UpdateDeskLedJob).to have_received(:perform_now).with(desk_booking.id, 'RED')
      end
    end

    context 'when the desk booking is active and booked' do
      let(:initial_state) { 'booked' }

      it 'triggers UpdateDeskLedJob with RED color' do
        allow(desk_booking).to receive(:active?).and_return(true)
        led_manager.perform!
        expect(DeskQ::UpdateDeskLedJob).to have_received(:perform_now).with(desk_booking.id, 'RED')
      end
    end

    context 'when the desk booking is not active and checked in' do
      let(:initial_state) { 'checked_in' }

      it 'triggers UpdateDeskLedJob with GREEN color' do
        allow(desk_booking).to receive(:active?).and_return(false)
        led_manager.perform!
        expect(DeskQ::UpdateDeskLedJob).to have_received(:perform_now).with(desk_booking.id, 'GREEN')
      end
    end

    context 'when the desk booking is not active and booked' do
      let(:initial_state) { 'booked' }

      it 'triggers UpdateDeskLedJob with GREEN color' do
        allow(desk_booking).to receive(:active?).and_return(false)
        led_manager.perform!
        expect(DeskQ::UpdateDeskLedJob).to have_received(:perform_now).with(desk_booking.id, 'GREEN')
      end
    end

    context 'when the desk booking is canceled' do
      let(:initial_state) { 'canceled' }

      it 'triggers UpdateDeskLedJob with GREEN color' do
        allow(desk_booking).to receive(:active?).and_return(false)
        led_manager.perform!
        expect(DeskQ::UpdateDeskLedJob).to have_received(:perform_now).with(desk_booking.id, 'GREEN')
      end
    end

    context 'when the desk booking is completed' do
      let(:initial_state) { 'checked_out' }

      it 'triggers UpdateDeskLedJob with GREEN color' do
        allow(desk_booking).to receive(:active?).and_return(false)
        led_manager.perform!
        expect(DeskQ::UpdateDeskLedJob).to have_received(:perform_now).with(desk_booking.id, 'GREEN')
      end
    end
  end
end
