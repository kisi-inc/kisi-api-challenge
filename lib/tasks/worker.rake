# frozen_string_literal: true
require_relative("../pubsub")
require 'google/cloud/pubsub'
require 'active_job/queue_adapters/pubsub_adapter'
require 'json'

namespace(:worker) do
  desc("Run the worker")
  task(run: :environment) do
    # See https://googleapis.dev/ruby/google-cloud-pubsub/latest/index.html
    
    puts("Worker starting...")
    pubsub = PubSub.new.client
    
    messages =[]

    #Pulling existing messages from all topics and all subcriptions from client
    topics = pubsub.topics

    topics.each do |topic|
      puts "Looping in topic #{topic.name}"

      topic = pubsub.topic(topic.name)
      subscriptions = topic.subscriptions

      subscriptions.each do |subscription|
        subscriber = subscription.listen do |received_message|
            messages << received_message.data
            puts "Received message: #{received_message.data}"
            received_message.acknowledge!
        end

        #Receiving messages
        puts("Receiving data...")

        subscriber.start
        sleep 30
        subscriber.stop!

      end
    end

    #Executing jobs
    puts("Executing jobs...")

    messages.each do |message|
      job = (JSON.parse(message))["queue_name"]
      job.constantize.set(queue: :job).perform_now("#{job} +1")
    end
  end
end