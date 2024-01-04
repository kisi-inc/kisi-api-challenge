# frozen_string_literal: true

module ActiveJob
  module QueueAdapters
    class PubsubAdapter
      # Enqueue a job to be performed.
      #
      # @param [ActiveJob::Base] job The job to be performed.
      def enqueue(job)
        serialized_job = serialize_job(job)
        pubsub = Pubsub.new
        pubsub.publish("general_jobs_queue", serialized_job)
      rescue Google::Cloud::Error => e
        Rails.logger.error("Unexpected GCP error while enqueueing job #{job.class.name}: #{e.message}")
      rescue StandardError => e
        Rails.logger.error("Unexpected error while enqueueing job #{job.class.name}: #{e.message}")
      end

      # Enqueue a job to be performed at a certain time.
      #
      # @param [ActiveJob::Base] job The job to be performed.
      # @param [Float] timestamp The time to perform the job.
      def enqueue_at(job, timestamp)
        Rails.logger.info("Scheduling job #{job.class.name} to be performed at #{Time.at(timestamp)}")
        serialized_job = serialize_job(job, timestamp)
        pubsub = Pubsub.new
        pubsub.publish("general_jobs_queue", serialized_job)
      rescue Google::Cloud::Error => e
        Rails.logger.error("Unexpected GCP error while enqueueing job #{job.class.name}: #{e.message}")
      rescue StandardError => e
        Rails.logger.error("Unexpected error while enqueueing job #{job.class.name}: #{e.message}")
      end

      private

      def serialize_job(job, timestamp = nil)
        {
          job_class: job.class.to_s,
          job_id: job.job_id,
          arguments: job.arguments,
          execute_at: timestamp
        }.to_json
      end
    end
  end
end
