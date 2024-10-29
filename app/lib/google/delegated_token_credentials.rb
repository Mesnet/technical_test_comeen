# frozen_string_literal: true

module Google
  class DelegatedTokenCredentials < Signet::OAuth2::Client
    attr_reader :grant, :owner, :domain

    def initialize(integration_grant)
      @grant = integration_grant
      @owner = integration_grant.user
      @domain = integration_grant.domain

      super(
        client_id: Rails.configuration.google_sheets[:client_id],
        client_secret: Rails.configuration.google_sheets[:client_secret],
        authorization_uri: "https://accounts.google.com/o/oauth2/v2/auth",
        token_credential_uri: "https://oauth2.googleapis.com/token",
        include_granted_scopes: false,
        redirect_uri: "https://example.client.com/oauth",
        scope: Rails.configuration.integrations.dig(:google, integration_grant.domain, :scopes),
        )
    end

    def destroy
      OauthToken.where(integration_grant: grant).destroy_all
    end
  end
end
