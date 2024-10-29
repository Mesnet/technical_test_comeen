# frozen_string_literal: true

require_dependency "google"

module Google
  class OauthToken < ApplicationRecord
    belongs_to :integration_grant

    validates :access_token, presence: true
    validates :refresh_token, presence: true
    validates :expires_at, presence: true
  end
end
