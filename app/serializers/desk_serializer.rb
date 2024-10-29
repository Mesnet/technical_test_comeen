# frozen_string_literal: true

class DeskSerializer
  include JSONAPI::Serializer

  set_type :desk
  attributes :name

  has_many :desk_bookings
end
