# frozen_string_literal: true

namespace(:worker) do
  desc("Run the worker")
  task(run: :environment) do
    # See https://googleapis.dev/ruby/google-cloud-pubsub/latest/index.html

    puts("Worker starting...")
    job_data = JSON.parse(message)
      job = ActiveJob::Base.deserialize(job_data)
      job.perform_now
    # Block, letting processing threads continue in the background
    sleep
  end
end
