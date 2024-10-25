# frozen_string_literal: true

class DeskBooking < ApplicationRecord
  belongs_to :desk
  belongs_to :user

  validates :start_datetime, :end_datetime, presence: true
end
