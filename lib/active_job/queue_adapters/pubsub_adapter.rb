# frozen_string_literal: true
require 'json'
require 'google/cloud/pubsub'
require_relative("../../pubsub")

module ActiveJob
  module QueueAdapters
    class PubsubAdapter
      
      def initialize(async: true, pubsub: PubSub.new.client)
        @executor = async ? :io : :immediate
        @pubsub   = pubsub
      end

      # Enqueue a job to be performed.
      #
      # @param [ActiveJob::Base] job The job to be performed.
      def enqueue(job, attributes = {})
        puts "Enqueueing job #{job} with attributes #{attributes}"
        @pubsub.topic(job.queue_name).publish JSON.dump(job.serialize), attributes
      end

      # Enqueue a job to be performed at a certain time.
      #
      # @param [ActiveJob::Base] job The job to be performed.
      # @param [Float] timestamp The time to perform the job.
      def enqueue_at(job, timestamp)
        enqueue job, timestamp: timestamp 
      end
    end
  end
end