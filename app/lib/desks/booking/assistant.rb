# frozen_string_literal: true

module Desks
  module Booking
    class NoDeskAvailableError < StandardError; end

    class Assistant
      attr_reader :user, :starting, :ending

      def initialize(user, starting_datetime, ending_datetime)
        @user = user
        @starting = starting_datetime
        @ending = ending_datetime
      end

      def book(desk: nil)
        with_available_desk(desk: desk) do |desk|
          DeskBooking.create(user:, desk: desk, start_datetime: starting, end_datetime: ending)
        end
      end

      def with_available_desk(desk: nil)
        desk ||= select_random_available_desk
        raise "No available desks" unless desk

        yield desk
      end

      private

      def select_random_available_desk
        available_desks = Desk.where.not(id: booked_desks)

        available_desks.sample
      end

      def booked_desks
        Desk.joins(:desk_bookings).merge(DeskBooking.overlapping(starting, ending))
      end
    end
  end
end
