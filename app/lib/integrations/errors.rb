# frozen_string_literal: true

module Integrations
  module Errors
    class IntegrationError < StandardError
      attr_reader :provider, :domain

      def initialize(provider = nil, domain = nil)
        @provider = provider
        @domain = domain

        message = "Integration error for #{provider} #{domain}"

        super(message)
      end
    end

    class GrantNotFound < IntegrationError; end
  end
end
