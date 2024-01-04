# frozen_string_literal: true

namespace(:worker) do
  desc("Run the worker")
  task(run: :environment) do
    puts("Worker starting...")

    pubsub = Pubsub.new
    subscription = pubsub.subscribe("general_jobs_queue_subscription")

    subscriber = subscription.listen do |received_message|
      job_data = JSON.parse(received_message.data)
      execute_at = job_data["execute_at"]
      retry_count = job_data["retry_count"] || 0

      if execute_at.nil? || Time.now.to_i >= execute_at
        process_job(job_data)
        received_message.acknowledge!
      else
        puts("Job scheduled for future execution at #{Time.at(execute_at)}")
        handle_delayed_job(job_data, received_message, retry_count)
      end
    rescue StandardError => e
      puts("Failed to process message: #{e.message}")
      handle_failed_job(job_data, received_message, retry_count)
    end

    subscriber.start

    # Block to keep the rake task running
    sleep
  end

  def process_job(job_data)
    job_class = job_data["job_class"].constantize
    job = job_class.new(*job_data["arguments"])
    job.perform_now
    puts("Processed job: #{job_data['job_class']}")
  end

  def handle_delayed_job(job_data, received_message, retry_count)
    puts("Job scheduled for future execution at #{Time.at(job_data['execute_at'])}")
    # Re-enqueue the job with the same retry_count
    pubsub = Pubsub.new
    pubsub.publish("general_jobs_queue", job_data.merge("retry_count" => retry_count).to_json)
    received_message.acknowledge!
  end

  def handle_failed_job(job_data, received_message, retry_count)
    if retry_count < 2
      # Schedule the job to be retried in 5 minutes
      delay_until = Time.now.to_i + 1 # 5 minutes in seconds
      # delay_until = Time.now.to_i + (5 * 60) # 5 minutes in seconds
      job_data_with_delay = job_data.merge("retry_count" => retry_count + 1, "execute_at" => delay_until)

      pubsub = Pubsub.new
      pubsub.publish("general_jobs_queue", job_data_with_delay.to_json)
    else
      puts("Maximum retries reached, moving job to morgue queue: #{job_data['job_class']}")
      pubsub = Pubsub.new
      pubsub.publish("morgue_jobs_queue", job_data.to_json)
    end
    received_message.acknowledge!
  end
end
