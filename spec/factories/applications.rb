# frozen_string_literal: true

FactoryBot.define do
  factory :application, class: "Doorkeeper::Application" do
    name { Faker::App.name }
    redirect_uri { "https://example.org/callback" }
  end
end
