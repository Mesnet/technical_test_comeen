# frozen_string_literal: true

module Google
  class OauthToken < ApplicationRecord
    belongs_to :integration_grant

    validates :access_token, presence: true
    validates :refresh_token, presence: true
    validates :expires_at, presence: true
  end
end
