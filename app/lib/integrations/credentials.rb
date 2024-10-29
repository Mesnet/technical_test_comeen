# frozen_string_literal: true

module Integrations
  class UnknownProviderError < StandardError; end

  class Credentials
    class << self
      def resolve(provider, domain)
        case provider.to_sym
        when :google
          Google::DelegatedTokenCredentials
        else
          raise UnknownProviderError, "Unknown provider: #{provider}"
        end
      end
    end
  end
end
