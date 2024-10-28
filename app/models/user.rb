# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable

  has_many :desk_bookings, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :time_zone, presence: true, inclusion: { in: TZInfo::Timezone.all_identifiers }
end
