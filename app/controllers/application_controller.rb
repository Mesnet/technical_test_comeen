# frozen_string_literal: true

class ApplicationController < ActionController::API
  include JSONAPI::Errors

  respond_to :json

  def with_model_errors_handling
    return unless block_given?

    begin
      yield
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved, ActiveRecord::RecordNotDestroyed => e
      render(jsonapi_errors: e.record.errors, status: :unprocessable_entity)
    end
  end

  def current_user
    current_resource_owner
  end

  def current_resource_owner
    return unless doorkeeper_token

    @current_resource_owner ||= if doorkeeper_token.resource_owner_id.present?
      User.find(doorkeeper_token.resource_owner_id)
    end
  end
end
