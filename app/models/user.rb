# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable

  # rubocop:disable Rails/InverseOf (the Doorkeeper's models do not have the corresponding associations)
  has_many :access_grants,
    class_name: "Doorkeeper::AccessGrant",
    foreign_key: :resource_owner_id,
    dependent: :delete_all # faster than :destroy since we're not running callbacks

  has_many :access_tokens,
    class_name: "Doorkeeper::AccessToken",
    foreign_key: :resource_owner_id,
    dependent: :delete_all # faster than :destroy since we're not running callbacks
  # rubocop:enable Rails/InverseOf

  has_many :desk_bookings, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :time_zone, presence: true, inclusion: { in: TZInfo::Timezone.all_identifiers }
end
