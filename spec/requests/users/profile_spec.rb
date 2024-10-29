# frozen_string_literal: true

require "swagger_helper"
require "shared/shared_context_for_authorized_requests"

USER_PARAMS = {
  type: :object,
  properties: {
    email: { type: :string },
    password: { type: :string },
    time_zone: { type: :string },
  },
}.freeze

RSpec.describe("users/profile", type: :request) do
  include_context "authorized app request"

  let(:Authorization) { "Bearer #{user_token.token}" }

  path "/users" do
    get("list user profiles") do
      tags "Users"
      security [apiOauth: []]

      produces "application/json"

      let!(:user_models) { FactoryBot.create_list(:user, 3) }

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

    post("create user profile") do
      tags "Users"
      security [apiOauth: []]

      consumes "application/json"
      produces "application/json"

      parameter name: "body", in: :body, schema: { type: :object, properties: { user: USER_PARAMS } }

      response(201, "successful") do
        let(:body) { { user: FactoryBot.attributes_for(:user) } }

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

  path "/users/{id}" do
    parameter name: "id", in: :path, type: :integer, description: "User id"

    let(:other_user_model) { FactoryBot.create(:user) }
    let(:id) { other_user_model.id }

    get("show profile") do
      tags "Users"
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

      response(200, "successfully show current user's profile", document: false) do
        let(:id) { "me" }

        after do |example|
          parsed_response = JSON.parse(response.body, symbolize_names: true)

          expect(parsed_response.dig(:data, :id).to_i).to(eq(user_model.id))

          example.metadata[:response][:content] = {
            "application/json" => {
              example: parsed_response,
            },
          }
        end
        run_test!
      end
    end

    [:put, :patch].each do |http_method|
      send(http_method, "update profile") do
        tags "Users"
        security [apiOauth: []]

        consumes "application/json"
        produces "application/json"

        parameter name: "body", in: :body, schema: { type: :object, properties: { user: USER_PARAMS } }

        response(200, "successful") do
          let(:body) { { user: FactoryBot.attributes_for(:user) } }

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

    delete("delete profile") do
      tags "Users"
      security [apiOauth: []]

      produces "application/json"

      response(204, "successful") do
        run_test!
      end
    end
  end
end
