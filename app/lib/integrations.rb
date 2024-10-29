# frozen_string_literal: true

module Integrations
  class << self
    def for(user, provider, domain)
      grant = user.integration_grants.for(provider, domain).first

      return grant if grant.present?

      raise Integrations::Errors::GrantNotFound.new(provider, domain),
        "Could not find credentials grant for #{provider} #{domain}"
    end
  end
end
