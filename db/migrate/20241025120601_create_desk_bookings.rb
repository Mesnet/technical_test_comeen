# frozen_string_literal: true

class CreateDeskBookings < ActiveRecord::Migration[7.0]
  def change
    create_table(:desk_bookings) do |t|
      t.references(:desk, null: false, foreign_key: true)
      t.references(:user, null: false, foreign_key: true)
      t.datetime(:start_datetime)
      t.datetime(:end_datetime)

      t.timestamps
    end
  end
end
