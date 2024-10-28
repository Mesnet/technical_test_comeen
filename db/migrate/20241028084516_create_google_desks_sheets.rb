# frozen_string_literal: true

class CreateGoogleDesksSheets < ActiveRecord::Migration[7.0]
  def change
    create_table(:google_desk_sheets) do |t|
      t.string(:google_sheet_id)

      t.datetime(:last_synced_at)
      t.timestamps
    end

    add_index(:google_desk_sheets, :google_sheet_id, unique: true)
  end
end
