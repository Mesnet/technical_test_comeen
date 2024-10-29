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

  def check_in
    with_model_errors_handling do
      @desk_booking.check_in!

      render(jsonapi: desk, status: :created)
    end
  end

  def check_out
    with_model_errors_handling do
      @desk_booking.check_out!

      render(jsonapi: @desk)
    end
  end

  def destroy
    with_model_errors_handling do
      @desk_booking.cancel!

      head(:no_content)
    end
  end

  private

  def load_desk_booking
    @desk_booking = DeskBooking.find(params[:id])
  end
end
