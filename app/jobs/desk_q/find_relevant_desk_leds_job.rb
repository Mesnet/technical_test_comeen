# app/jobs/desk_q/find_relevant_desk_leds_job.rb
class DeskQ::FindRelevantDeskLedsJob < ApplicationJob
  queue_as :default

  def perform
    process_starting_soon
    process_ending_soon
  rescue => e
    Rails.logger.error("Failed to process LED updates for relevant desk bookings: #{e.message}")
  end

  private

  def process_starting_soon
    DeskBooking.starting_soon.find_each do |desk_booking|
      update_led_color(desk_booking.desk.sync_id, "RED")
    end
  end

  def process_ending_soon
    DeskBooking.ending_soon.find_each do |desk_booking|
      update_led_color(desk_booking.desk.sync_id, "GREEN")
    end
  end

  def update_led_color(sync_id, color)
    DeskQ::UpdateDeskLedJob.perform_now(sync_id, color)
  end
end
