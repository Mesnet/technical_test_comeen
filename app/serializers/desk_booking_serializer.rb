# frozen_string_literal: true

class DeskBookingSerializer
  include JSONAPI::Serializer

  set_type :desk_booking
  attributes :start_datetime, :end_datetime, :state

  belongs_to :user
  belongs_to :desk
end
