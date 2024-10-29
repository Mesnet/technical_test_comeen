# frozen_string_literal: true

class UserSerializer
  include JSONAPI::Serializer

  set_type :user
  attributes :email, :time_zone

  has_many :desk_bookings
end
