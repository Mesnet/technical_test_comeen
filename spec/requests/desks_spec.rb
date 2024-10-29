# frozen_string_literal: true

require "swagger_helper"
require "shared/shared_context_for_authorized_requests"

DESK_PARAMS = {
  type: :object,
  properties: {
    name: { type: :string },
  },
}.freeze

RSpec.describe("desks", type: :request) do
  include_context "authorized app request"

  let(:Authorization) { "Bearer #{user_token.token}" }

  path "/desks" do
    get("list desks") do
      tags "Desks"
      security [apiOauth: []]

      produces "application/json"

      let!(:desks) { FactoryBot.create_list(:desk, 10) }

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

    post("create desk") do
      tags "Desks"
      security [apiOauth: []]

      consumes "application/json"
      produces "application/json"

      parameter name: "body", in: :body, schema: { type: :object, properties: { desk: DESK_PARAMS } }

      response(201, "successful") do
        let(:body) { { desk: FactoryBot.attributes_for(:desk) } }

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

  path "/desks/{id}" do
    parameter name: "id", in: :path, type: :integer, description: "Desk id"

    let(:desk_model) { FactoryBot.create(:desk) }
    let(:id) { desk_model.id }

    get("show desk") do
      tags "Desks"
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

    [:patch, :put].each do |http_method|
      send(http_method, "update desk") do
        tags "Desks"
        security [apiOauth: []]

        consumes "application/json"
        produces "application/json"

        parameter name: "body", in: :body, schema: { type: :object, properties: { desk: DESK_PARAMS } }

        response(200, "successful") do
          let(:body) { { desk: FactoryBot.attributes_for(:desk) } }

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

    delete("delete desk") do
      response(204, "successful") do
        run_test!
      end
    end
  end
end
