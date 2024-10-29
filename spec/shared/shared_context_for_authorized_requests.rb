# frozen_string_literal: true

RSpec.shared_context("authorized app request") do
  let(:required_scopes) { [] }
  let(:application) { FactoryBot.create(:application, scopes: required_scopes) }

  let(:user_model) { FactoryBot.create(:user) }
  let(:user_token) do
    FactoryBot.create(
      :access_token,
      application:,
      resource_owner_id: user_model.id,
      scopes: required_scopes,
    )
  end
end
