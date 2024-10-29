# frozen_string_literal: true

module Google
  class DeskSheetsController < ApplicationController
    before_action :load_desk_sheet, except: [:index, :create]

    def index
      @desk_sheets = DeskSheet.all

      render(jsonapi: @desk_sheets)
    end

    def create
      @desk_sheet = DeskSheet.new(desk_sheet_params)

      with_model_errors_handling do
        @desk_sheet.save!

        render(jsonapi: @desk_sheet, status: :created)
      end
    end

    def destroy
      with_model_errors_handling do
        @desk_sheet.destroy

        head(:no_content)
      end
    end

    def list_sync_changes
      @desks_from_sheet = @desk_sheet.fetch_sync_changes

      render(jsonapi: @desks_from_sheet)
    end

    def commit_sync
      @desks_from_sheet = @desk_sheet.fetch_sync_changes
      with_model_errors_handling do
        Desk.transaction do
          @desks_from_sheet.each(&:save!)
        end

        render(jsonapi: @desks_from_sheet)
      end
    end

    private

    def desk_sheet_params
      params.require(:desk_sheet).permit(:google_sheet_id) # replace with actual attributes
    end
  end
end
