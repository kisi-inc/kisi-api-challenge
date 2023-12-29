# frozen_string_literal: true

namespace(:worker) do
  desc("Run the worker")
  task(run: :environment) do
    # See https://googleapis.dev/ruby/google-cloud-pubsub/latest/index.html

    puts("Worker starting...")

    pubsub = Pubsub.new
    subscription = pubsub.client.subscription('general_jobs_queue_subscription')

    subscriber = subscription.listen do |received_message|
      begin
        job_data = JSON.parse(received_message.data)

        job_class = job_data['job_class'].constantize
        job = job_class.new(*job_data['arguments'])
        job.perform_now

        received_message.acknowledge!
      rescue StandardError => e
        puts "Failed to process message: #{e.message}"
        # TODO LOGIC FOR ERRORS
      end
    end

    subscriber.start
    sleep
  end
end
