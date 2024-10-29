# frozen_string_literal: true

class ApplicationController < ActionController::API
  include JSONAPI::Errors

  respond_to :json

  def with_model_errors_handling
    return unless block_given?

    begin
      yield
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotSaved, ActiveRecord::RecordNotDestroyed => e
      render(jsonapi: e.record.errors, status: :unprocessable_entity)
    end
  end

  def current_user
    current_resource_owner
  end
end
