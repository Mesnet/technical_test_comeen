# frozen_string_literal: true

require "swagger_helper"
require "shared/shared_context_for_authorized_requests"

DESK_SHEET_PARAMS = {
  type: :object,
  properties: {
    google_sheet_id: { type: :string },
  },
}

RSpec.describe("google/desk_sheets", type: :request) do
  include_context "authorized app request"

  let(:Authorization) { "Bearer #{user_token.token}" }

  let(:desk_sheet_model) { Google::DeskSheet.create!(google_sheet_id: "5ryHHFcj1cnimHvv678t7SivrCrMHrnmfqd") }

  path "/google/desk_sheets/{id}/sync" do
    parameter name: "id", in: :path, type: :string, description: "Desk sheet id"

    let!(:integration_grant_model) { IntegrationGrant.create(user: user_model, provider: :google, domain: :sheets) }

    let(:id) { desk_sheet_model.id }

    get("list changes to desks in desk sheet") do
      tags "Google Sheets Desk Sync"
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

    post("apply changes made to desks in desk sheet") do
      tags "Google Sheets Desk Sync"
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

  path "/google/desk_sheets" do
    get("list desk sheets") do
      tags "Google Sheets Desk Sync"
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

    post("create Desk sheet") do
      tags "Google Sheets Desk Sync"
      security [apiOauth: []]

      consumes "application/json"
      produces "application/json"

      parameter name: "body", in: :body, schema: { type: :object, properties: { desk_sheet: DESK_SHEET_PARAMS } }

      let(:body) { { desk_sheet: { google_sheet_id: "5ryHHFcj1cnimHvv678t7SivrCrMHrnmfqd" } } }

      response(201, "successful") do
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

  path "/google/desk_sheets/{id}" do
    # You'll want to customize the parameter types...
    parameter name: "id", in: :path, type: :integer, description: "Desk sheet id"

    let(:id) { desk_sheet_model.id }

    delete("delete desk_sheet") do
      response(204, "successful") do
        run_test!
      end
    end
  end
end
