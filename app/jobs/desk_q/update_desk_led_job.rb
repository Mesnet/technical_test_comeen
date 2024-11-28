class DeskQ::UpdateDeskLedJob < ApplicationJob
  queue_as :default

  def perform(desk_booking_id, color)
    desk_booking = DeskBooking.find_by(id: desk_booking_id)

		if desk_booking.nil?
      Rails.logger.warn "UpdateDeskLedJob: DeskBooking is nil."
      return
    end

    desk_sync_id = desk_booking.desk.sync_id
    DeskQ::Api.new.update(desk_sync_id, { color: color })
  rescue StandardError => e
    Rails.logger.error "UpdateDeskLedJob: Failed to update LED for DeskBooking #{desk_booking_id} with error: #{e.message}"
  end
end
