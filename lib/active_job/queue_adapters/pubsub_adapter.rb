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
        pubsub.publish('general_jobs_queue', serialized_job)
      end

      # Enqueue a job to be performed at a certain time.
      #
      # @param [ActiveJob::Base] job The job to be performed.
      # @param [Float] timestamp The time to perform the job.
      def enqueue_at(job, timestamp)
        p "ENQUEUE_AT"
        raise(NotImplementedError)
      end

      private

      def serialize_job(job)
        {
          job_class: job.class.to_s,
          job_id: job.job_id,
          arguments: job.arguments
        }.to_json
      end
    end
  end
end
