# frozen_string_literal: true

FactoryBot.define do
  factory :desk_booking do
    user
    desk

    transient do
      starting { Faker::Time.forward(days: 5, period: :morning) }
      ending { starting + 8.hours }
    end

    start_datetime { starting }
    end_datetime { ending }
    status { "booked" }
  end
end
