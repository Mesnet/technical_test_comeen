# frozen_string_literal: true

require "rails_helper"

APP_HOST = if Rails.env.local?
  "localhost:#{ENV.fetch("PORT")}"
else
  ENV.fetch("HOST").freeze
end

PROTOCOL = if Rails.env.local?
  "http"
else
  "https"
end

BASE_URL = "#{PROTOCOL}://#{APP_HOST}".freeze

available_app_scopes = {}

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join("swagger")

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.openapi_specs = {
    "v1/swagger.yaml" => {
      openapi: "3.0.1",
      info: {
        title: "Desk booking API",
        version: "v1",
      },
      components: {
        securitySchemes: {
          apiOauth: {
            type: "oauth2",
            flows: {
              authorizationCode: {
                authorizationUrl: "#{BASE_URL}/oauth/authorize",
                tokenUrl: "#{BASE_URL}/oauth/token",
                scopes: available_app_scopes,
              },
            },
          },
        },
      },
      paths: {},
      servers: [
        {
          url: "/",
        },
      ],
    },
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The swagger_docs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml
end
