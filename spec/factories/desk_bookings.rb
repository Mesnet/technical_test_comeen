# frozen_string_literal: true

FactoryBot.define do
  factory :desk_booking do
    user
    desk

    start_time { Faker::Time.forward(days: 5, period: :morning) }
    end_time { start_time + 8.hours }
    status { "booked" }
  end
end
