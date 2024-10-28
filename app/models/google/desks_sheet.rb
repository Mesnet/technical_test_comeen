# frozen_string_literal: true

module Google
  class DeskSheet < ApplicationRecord
    validates :google_sheet_id, presence: true, uniqueness: true
  end
end
