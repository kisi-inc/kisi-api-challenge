# frozen_string_literal: true

module ActiveJob
  module QueueAdapters
    class PubsubAdapter
      # Enqueue a job to be performed.
      #
      # @param [ActiveJob::Base] job The job to be performed.
      def enqueue(job)
        puts "[PubSubQueueAdapter enqueue job #{job.inspect}]"

        Pubsub.new.topic("default").publish(job.class.name, arg: job.arguments)
      end

      # Enqueue a job to be performed at a certain time.
      #
      # @param [ActiveJob::Base] job The job to be performed.
      # @param [Float] timestamp The time to perform the job.
      def enqueue_at(job, timestamp)
        puts "[PubSubQueueAdapter enqueue job at: #{timestamp} - #{job.inspect}]"

        delay = timestamp - Time.current.to_f
        if delay > 0
          Concurrent::ScheduleTask.execute(delay) { enqueue(job) }
        else
          enqueue(job)
        end
      end
    end
  end
end
