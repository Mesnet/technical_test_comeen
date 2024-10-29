# frozen_string_literal: true

FactoryBot.define do
  factory :access_token, class: "Doorkeeper::AccessToken" do
    application
    resource_owner factory: :user
    expires_in { 2.hours }
  end
end
