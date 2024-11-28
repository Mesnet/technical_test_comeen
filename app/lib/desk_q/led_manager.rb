class DeskQ::LedManager
  def initialize(desk_booking)
    @desk_booking = desk_booking
    @user = desk_booking.user
  end

  def perform!
    handle_led_status!
  end

  private

  def handle_led_status!
    DeskQ::UpdateDeskLedJob.perform_now(@desk_booking.id, relevant_color)
  end

  def relevant_color
    if @desk_booking.active? && (@desk_booking.checked_in? || @desk_booking.booked?)
      "RED"
    else
      "GREEN"
    end
  end
end