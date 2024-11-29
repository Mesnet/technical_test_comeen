# frozen_string_literal: true

class DeskBooking < ApplicationRecord
  include AASM

  belongs_to :desk
  belongs_to :user

  validates :start_datetime, :end_datetime, presence: true

  scope :overlapping, ->(start_datetime, end_datetime) do
    where(
      "`start_datetime` BETWEEN :starting AND :ending OR " \
        "`end_datetime` BETWEEN :starting AND :ending OR " \
        "(`start_datetime` < :starting AND `end_datetime` > :ending)",
      starting: start_datetime,
      ending: end_datetime,
    )
  end

  scope :starting_soon, -> {
    includes(:desk).where('start_datetime <= ? AND end_datetime >= ? AND state IN (?)', 15.minutes.from_now, Time.current, ['booked', 'checked_in'])
  }

  scope :ending_soon, -> {
    includes(:desk).where('end_datetime <= ? AND state IN (?)', 15.minutes.from_now, ['booked', 'checked_in'])
  }

  aasm column: :state do
    state :booked, initial: true
    state :canceled
    state :checked_in
    state :checked_out

    event :check_in do
      transitions from: :booked, to: :checked_in, guard: :can_checkin?
    end

    event :check_out do
      transitions from: :checked_in, to: :checked_out
    end

    event :cancel do
      transitions from: [:booked, :checked_in], to: :canceled
    end
  end

  def can_checkin?
    start_datetime < Time.current
  end

  def active?
    return false unless start_datetime && end_datetime

    Time.current.between?(start_datetime, end_datetime)
  end
end
