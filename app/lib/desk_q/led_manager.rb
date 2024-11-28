class DeskQ::LedManager
  def initialize(desk_booking)
    @desk_booking = desk_booking
    @user = desk_booking.user
    @desk = desk_booking.desk
  end

  def perform!
    case @desk_booking.state
    when 'booked'
      handle_booked
    when 'checked_out', 'canceled'
      handle_canceled_or_checked_out
    else
      Rails.logger.warn "DeskQ::LedManager: Unsupported state #{@desk_booking.state}"
    end
  end

  private

  def handle_booked
    if @desk_booking.active?
      # If the booking is active, set the LED to RED immediately
      enqueue_led_job(Time.current, 'RED')
    else
      enqueue_led_job(@desk_booking.start_datetime, 'RED')
    end

    enqueue_led_job(@desk_booking.end_datetime, 'GREEN')
  end

  def handle_canceled_or_checked_out
    cancel_existing_jobs!

    if @desk_booking.active?
      # If the booking is active, set the LED to GREEN immediately
      enqueue_led_job(Time.current, 'GREEN')
    end
  end

  def cancel_existing_jobs!
    ActiveJob::Base.queue_adapter.enqueued_jobs.each do |job|
      if job[:args]&.include?(@desk_booking.id)
        ActiveJob::Base.queue_adapter.cancel(job[:job_id])
      end
    end
  end

  def enqueue_led_job(time, color)
    if should_run_now?(time)
      UpdateDeskLedJob.perform_now(@desk_booking.id, color)
    else
      UpdateDeskLedJob.perform_later(@desk_booking.id, color)
    end
  end

  def should_run_now?(time)
    user_time = time.in_time_zone(@user.time_zone)
    user_time <= Time.current
  end
end