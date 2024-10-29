# frozen_string_literal: true

require_dependency "google"

module Google
  class DeskSheet < ApplicationRecord
    validates :google_sheet_id, presence: true, uniqueness: true
  end
end
