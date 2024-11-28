class DeskQ::UpdateDeskLedJob < ApplicationJob
  queue_as :default

  def perform(desk_sync_id, color)
    DeskQ::Api.new.update(desk_sync_id, { color: color })
  rescue StandardError => e
    Rails.logger.error "UpdateDeskLedJob: Failed to update LED for DeskSyncId #{desk_sync_id} with error: #{e.message}"
  end
end
