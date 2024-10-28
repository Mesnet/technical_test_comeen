# frozen_string_literal: true

class AddGoogleDeskSheetIdToDesks < ActiveRecord::Migration[7.0]
  def change
    # Desks can be synced with a Google Sheet, but can also be created manually
    add_reference(:desks, :google_desk_sheet, null: true, foreign_key: true)
  end
end
