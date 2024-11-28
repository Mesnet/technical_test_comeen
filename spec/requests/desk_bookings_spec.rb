# frozen_string_literal: true

require "swagger_helper"
require "shared/shared_context_for_authorized_requests"

DESK_BOOKING_PARAMS = {
  type: :object,
  properties: {
    start_datetime: { type: :string, format: "date-time" },
    end_datetime: { type: :string, format: "date-time" },
  },
}.freeze


RSpec.describe("desk_bookings", type: :request) do
  include_context "authorized app request"

  let(:Authorization) { "Bearer #{user_token.token}" }

  before do
    # Mock the DeskQ::Api update method to prevent real API calls
    allow_any_instance_of(DeskQ::Api).to receive(:update).and_return(true)
  end

  path "/desks/{id}/book" do
    parameter name: "id", in: :path, type: :integer, description: "Desk id"

    let(:desk_model) { FactoryBot.create(:desk) }
    let(:id) { desk_model.id }

    post("book a desk") do
      tags "Desks", "Desk Bookings"
      security [apiOauth: []]

      consumes "application/json"
      produces "application/json"

      parameter name: "body", in: :body, schema: { type: :object, properties: { desk_booking: DESK_BOOKING_PARAMS } }

      response(201, "successful") do
        let(:body) { { desk_booking: FactoryBot.attributes_for(:desk_booking) } }

        after do |example|
          example.metadata[:response][:content] = {
            "application/json" => {
              example: JSON.parse(response.body, symbolize_names: true),
            },
          }
        end
        run_test!
      end
    end
  end

  path "/desk_bookings/{id}/check_in" do
    parameter name: "id", in: :path, type: :integer, description: "Desk booking id"

    let(:start_datetime) { 10.minutes.ago }
    let(:desk_booking_model) do
      FactoryBot.create(:desk_booking, start_datetime:, end_datetime: start_datetime + 9.hours)
    end
    let(:id) { desk_booking_model.id }

    post("check-in desk_booking") do
      tags "Desks", "Desk Bookings"
      security [apiOauth: []]

      produces "application/json"

      response(200, "successful") do
        after do |example|
          example.metadata[:response][:content] = {
            "application/json" => {
              example: JSON.parse(response.body, symbolize_names: true),
            },
          }
        end
        run_test!
      end
    end
  end

  path "/desk_bookings/{id}/check_out" do
    parameter name: "id", in: :path, type: :integer, description: "Desk booking id"

    let(:start_datetime) { 10.minutes.ago }
    let(:desk_booking_model) do
      FactoryBot.create(:desk_booking, state: "checked_in", start_datetime:, end_datetime: start_datetime + 9.hours)
    end
    let(:id) { desk_booking_model.id }

    post("check-out desk_booking") do
      tags "Desks", "Desk Bookings"
      security [apiOauth: []]

      produces "application/json"

      response(200, "successful") do
        after do |example|
          example.metadata[:response][:content] = {
            "application/json" => {
              example: JSON.parse(response.body, symbolize_names: true),
            },
          }
        end
        run_test!
      end
    end
  end

  path "/desk_bookings" do
    let!(:desk_bookings) { FactoryBot.create_list(:desk_booking, 10) }
    let(:unbooked_desk) { FactoryBot.create(:desk) }

    get("list desk bookings") do
      response(200, "successful") do
        after do |example|
          example.metadata[:response][:content] = {
            "application/json" => {
              example: JSON.parse(response.body, symbolize_names: true),
            },
          }
        end
        run_test!
      end
    end

    post("book any desk") do
      tags "Desks", "Desk Bookings"
      security [apiOauth: []]

      consumes "application/json"
      produces "application/json"

      parameter name: "body", in: :body, schema: { type: :object, properties: { desk_booking: DESK_BOOKING_PARAMS } }

      response(201, "successful") do
        let(:body) { { desk_booking: FactoryBot.attributes_for(:desk_booking) } }

        after do |example|
          example.metadata[:response][:content] = {
            "application/json" => {
              example: JSON.parse(response.body, symbolize_names: true),
            },
          }
        end
        run_test!
      end
    end
  end

  path "/desk_bookings/{id}" do
    parameter name: "id", in: :path, type: :integer, description: "Desk booking id"

    let(:desk_booking_model) { FactoryBot.create(:desk_booking) }
    let(:id) { desk_booking_model.id }

    get("show desk booking") do
      response(200, "successful") do
        after do |example|
          example.metadata[:response][:content] = {
            "application/json" => {
              example: JSON.parse(response.body, symbolize_names: true),
            },
          }
        end
        run_test!
      end
    end

    delete("delete desk_booking") do
      response(204, "successful") do
        run_test!
      end
    end
  end
end
