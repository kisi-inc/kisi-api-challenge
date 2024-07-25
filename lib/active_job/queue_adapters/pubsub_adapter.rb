# frozen_string_literal: true
require ("google/cloud/pubsub")

module ActiveJob
  module QueueAdapters
    class PubsubAdapter
      # Enqueue a job to be performed.
      #
      # @param [ActiveJob::Base] job The job to be performed.
      def enqueue(job)
        payload = job.serialize.to_json
        topic_name = 'jobs' # Default topic name
        Pubsub.publish(payload, topic_name)
      end

      # Enqueue a job to be performed at a certain time.
      #
      # @param [ActiveJob::Base] job The job to be performed.
      # @param [Float] timestamp The time to perform the job.
      def enqueue_at(job, timestamp)
        raise NotImplementedError, "This adapter does not support delayed jobs"
      end
    end
  end
end
