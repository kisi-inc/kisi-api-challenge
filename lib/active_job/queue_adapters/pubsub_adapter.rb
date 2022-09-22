# frozen_string_literal: true

module ActiveJob
  module QueueAdapters
    class PubsubAdapter
      attr_writer(:enqueued_jobs)

      # Enqueue a job to be performed.
      #
      # @param [ActiveJob::Base] job The job to be performed.
      def enqueue(job)
        puts("Enqueing job #{job.inspect}")
        job_data = job_to_hash(job)
        perform(job, job_data)
      end

      # Enqueue a job to be performed at a certain time.
      #
      # @param [ActiveJob::Base] job The job to be performed.
      # @param [Float] timestamp The time to perform the job.
      def enqueue_at(job, timestamp)
        delay = timestamp - Time.current.to_f
        t1 = Thread.new do
          sleep(delay)
          enqueue(job)
        end
        t1.join
      end

      def enqueued_jobs
        @enqueued_jobs ||= []
      end

      private

      def job_to_hash(job, extras = {})
        job.serialize.tap do |job_data|
          job_data[:job] = job.class
          job_data[:args] = job_data.fetch("arguments")
          job_data[:queue] = job_data.fetch("queue_name")
          job_data[:priority] = job_data.fetch("priority")
        end.merge(extras)
      end

      def perform(job, job_data)
        enqueued_jobs << job_data
        payload = job.class.to_s
        Rails.application.config.pubsub_client.publish(payload)
      end
    end
  end
end
