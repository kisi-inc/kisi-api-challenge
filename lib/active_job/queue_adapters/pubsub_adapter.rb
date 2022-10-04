# frozen_string_literal: true

module ActiveJob
  module QueueAdapters
    class PubsubAdapter
      # todo
      def initialize(async: true)
        @executor =  async ? :io : :immediate
        @pubsub = Pubsub.new
      end

      # Enqueue a job to be performed.
      #
      # @param [ActiveJob::Base] job The job to be performed.
      def enqueue(job)
        Concurrent::Promise.execute(executor: @executor) do
          perform(job)
        rescue StandardError => e
          puts(e.message)
          Rails.logger.error(e)
        end
      end

      # Enqueue a job to be performed at a certain time.
      #
      # @param [ActiveJob::Base] job The job to be performed.
      # @param [Float] timestamp The time to perform the job.
      def enqueue_at(job, timestamp)
        @timestamp = timestamp
        enqueue(job)
      end

      private

      def perform(job)
        if @timestamp.present?
          @pubsub.topic(job.queue_name).publish(JSON.dump(job.serialize), timestamp: @timestamp)
        else
          @pubsub.topic(job.queue_name).publish(JSON.dump(job.serialize))
        end
      end
    end
  end
end
