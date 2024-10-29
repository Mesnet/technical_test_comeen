# frozen_string_literal: true

class Desk < ApplicationRecord
  belongs_to :google_desk_sheet, optional: true, class_name: "Google::DeskSheet"
  has_many :desk_bookings, dependent: :destroy

  validates :name, presence: true
  validates :sync_id, uniqueness: true, allow_nil: true
end
