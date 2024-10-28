# frozen_string_literal: true

require "google/apis/sheets_v4"
require "googleauth"

module Google
  module Sheets
    class SheetsService
      def initialize(credentials)
        @service = Google::Apis::SheetsV4::SheetsService.new
        @service.client_options.application_name = "Desk Booking App"
        @service.authorization = authorize
      end

      def get_sheet(spreadsheet_id, range)
        # @service.get_spreadsheet_values(spreadsheet_id, range)

        # Mock data

        {
          values: [
            ["name", "sync_id"],
            ["Enginnering - 1", "B1F1D1"],
            ["Enginnering - 2", "B1F1D2"],
            ["Enginnering - 3", "B1F1D3"],
            ["Research - 1", "B1F2D1"],
            ["Research - 2", "B1F2D2"],
            ["Design - 1", "B2F1D1"],
            ["Design - 2", "B2F1D2"],
            ["Marketing - 1", "B2F2D1"],
            ["Marketing - 2", "B2F2D2"],
            ["Marketing - 3", "B2F2D3"],
          ],
        }
      end
    end
  end
end
