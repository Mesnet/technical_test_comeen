# frozen_string_literal: true

module Google
  class DeskSheetSerializer
    include JSONAPI::Serializer

    set_type :google_desk_sheet
    attributes :google_sheet_id
  end
end
