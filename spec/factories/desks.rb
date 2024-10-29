# frozen_string_literal: true

FactoryBot.define do
  factory :desk do
    transient do
      area { Faker::IndustrySegments.super_sector }
    end

    name { "#{area} - #{Random.rand(50)}" }
  end
end
