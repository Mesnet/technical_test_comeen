# frozen_string_literal: true

class Desk < ApplicationRecord
  has_many :desk_bookings, dependent: :destroy

  validates :name, presence: true
  validates :sync_id, presence: true, uniqueness: true
end
