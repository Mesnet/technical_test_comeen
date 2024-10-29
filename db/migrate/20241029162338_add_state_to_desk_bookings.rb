# frozen_string_literal: true

class AddStateToDeskBookings < ActiveRecord::Migration[7.2]
  def change
    add_column(:desk_bookings, :state, :string, null: false, default: "booked")
  end
end
