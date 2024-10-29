# frozen_string_literal: true

module Desks
  module Booking
    module Errors
      class DeskBookingError < StandardError
        attr_reader :record

        def initialize(record = nil)
          if record
            @record = record
            errors = @record.errors.full_messages.join(", ")
            message = I18n.t(
              :"#{@record.class.i18n_scope}.errors.messages.record_invalid",
              errors: errors,
              default: :"errors.messages.record_invalid",
            )
          else
            message = "Record invalid"
          end

          super(message)
        end
      end

      class NoDeskAvailableError < DeskBookingError; end
    end
  end
end
