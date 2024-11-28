# frozen_string_literal: true

# app/controllers/desks_controller.rb
class DeskBookingsController < ApplicationController
  before_action :load_desk_booking, only: [:show, :destroy, :check_in, :check_out]

  def index
    @desk_bookings = DeskBooking.all

    render(jsonapi: @desk_bookings)
  end

  def show
    render(jsonapi: @desk_booking)
  end

  def create
    @desk_booking = DeskBooking.new(desk_booking_params)
    @desk = @desk_booking.desk
    assist = Desks::Booking::Assistant.new(
      current_user,
      @desk_booking.start_datetime,
      @desk_booking.end_datetime,
    )

    with_model_errors_handling do
      @desk_booking = assist.book!(desk: @desk_booking.desk)
      DeskQ::UpdateDeskLedJob.perform_now(@desk_booking.desk.sync_id, "RED") if @desk_booking.active?

      render(jsonapi: @desk_booking, status: :created)
    rescue Desks::Booking::Errors::DeskBookingError => e
      render(jsonapi_errors: e.message, status: :unprocessable_entity)
    end
  end

  def check_in
    with_model_errors_handling do
      @desk_booking.check_in!

      render(jsonapi: @desk_booking)
    end
  end

  def check_out
    with_model_errors_handling do
      @desk_booking.check_out!
      DeskQ::UpdateDeskLedJob.perform_now(@desk_booking.desk.sync_id, "GREEN") if @desk_booking.active?

      render(jsonapi: @desk_booking)
    end
  end

  def destroy
    with_model_errors_handling do
      @desk_booking.cancel!
      DeskQ::UpdateDeskLedJob.perform_now(@desk_booking.desk.sync_id, "GREEN") if @desk_booking.active?

      head(:no_content)
    end
  end

  private

  def load_desk_booking
    @desk_booking = DeskBooking.find(params[:id])
  end

  def desk_booking_params
    params.require(:desk_booking).permit(:start_datetime, :end_datetime)
  end
end
