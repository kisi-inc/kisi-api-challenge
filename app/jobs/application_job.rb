# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  # in case of failure, retry job at most 2 times
  # in case of failure, retry job with wait interval minimum 5 minutes
  retry_on(StandardError, wait: 5.minutes, attempts: 2) do |job|
    job.enqueue(queue: "#{job.queue_name}-morgue")
  end
end
