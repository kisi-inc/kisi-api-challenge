# frozen_string_literal: true
require 'json'

module ActiveJob
  module QueueAdapters
    class PubsubAdapter
      # Enqueue a job to be performed.
      #
      # @param [ActiveJob::Base] job The job to be performed.
      def enqueue(job)
        puts "[PubSubQueueAdapter enqueue job #{job.inspect}]"

        if job.executions == 3
          Pubsub.new.topic("error_queue").publish(job.serialize.to_json)
        else
          Pubsub.new.topic(job.queue_name).publish(job.serialize.to_json)
        end
      end

      # Enqueue a job to be performed at a certain time.
      #
      # @param [ActiveJob::Base] job The job to be performed.
      # @param [Float] timestamp The time to perform the job.
      def enqueue_at(job, timestamp)
        delay = timestamp - Time.current.to_f

        if delay > 0
          thread = Thread.new do
            sleep(delay)
            enqueue(job)
          end

          # wait for the thread to finish
          thread.join()
        else
          enqueue(job)
        end
      end
    end
  end
end
