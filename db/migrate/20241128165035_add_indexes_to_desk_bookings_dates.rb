class AddIndexesToDeskBookingsDates < ActiveRecord::Migration[7.2]
  def change
    add_index :desk_bookings, :start_datetime
    add_index :desk_bookings, :end_datetime
  end
end
