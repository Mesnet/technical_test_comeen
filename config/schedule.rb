set :output, "log/cron_log.log" # Set output log for debugging

every 5.minutes do
  runner "UpdateRelevantDeskLedsJob.perform_now"
end
