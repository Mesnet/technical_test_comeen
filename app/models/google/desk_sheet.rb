# frozen_string_literal: true

require_dependency "google"

module Google
  class DeskSheet < ApplicationRecord
    validates :google_sheet_id, presence: true, uniqueness: true

    has_many :desks,
      foreign_key: :google_desk_sheet_id,
      dependent: :nullify,
      inverse_of: :google_desk_sheet
  end
end
