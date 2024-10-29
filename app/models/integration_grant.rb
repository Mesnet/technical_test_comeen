# frozen_string_literal: true

# Records that a user has granted access to an integration
class IntegrationGrant < ApplicationRecord
  belongs_to :user

  validates :provider, presence: true, inclusion: {
    in: Rails.application.config.integrations.keys,
  }
  validates :domain, presence: true, inclusion: {
    in: Rails.application.config.integrations.values.flat_map(&:keys),
  }

  normalizes :provider, with: ->(provider) { provider.to_sym }
  normalizes :domain, with: ->(domain) { domain.to_sym }

  scope :for, ->(provider, domain) { where(provider:, domain:) }

  def credentials
    Integrations::Credentials.resolve(provider, domain)
  end
end
