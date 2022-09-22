# frozen_string_literal: true

require("google/cloud/pubsub")

class Pubsub
  # Initialize PubSub
  #
  # @param topic [String] The name of the topic to find or create
  # @param subscription [String] The name of the subscription to find or create
  # @return [PubSub]
  def initialize(topic, subscription)
    @topic = topic(topic)
    @subscription = subscription
  end

  # Find or create a topic.
  #
  # @param topic [String] The name of the topic to find or create
  # @return [Google::Cloud::PubSub::Topic]
  def topic(name)
    client.topic(name) || client.create_topic(name)
  end

  # Find or create a subscription on the topic
  # @return [Google::Cloud::PubSub::Subscription]
  def subscription
    @topic.subscription(@subscription) || @topic.subscribe(@subscription)
  end

  # Publish message to pubsub
  # @param message [String] The message payload
  # @return [Google::Cloud::PubSub::Message]
  def publish(message)
    @topic.publish(message)
  end

  # Pulls messages from subscription and executes relevant job
  # More info: https://googleapis.dev/ruby/google-cloud-pubsub/latest/index.html#receiving-messages
  def start_listening
    sub = subscription
    subscriber = sub.listen(threads: { callback: 16 }) do |received_message|
      # process message
      puts("Data: #{received_message.message.data}, published at #{received_message.message.published_at}")
      received_message.acknowledge!
      execute_job(received_message.message.data)
    end

    # Handle exceptions from listener
    subscriber.on_error do |exception|
      puts("Exception: #{exception.class} #{exception.message}")
    end

    # Gracefully shut down the subscriber on program exit, blocking until
    # all received messages have been processed or 10 seconds have passed
    at_exit do
      subscriber.stop!(10)
    end

    # Start background threads that will call the block passed to listen.
    subscriber.start
  end

  private

  # Create a new client.
  #
  # @return [Google::Cloud::PubSub]
  def client
    @client ||= Google::Cloud::PubSub.new(project_id: "code-challenge")
  end

  # Execute relevant job
  def execute_job(job)
    job.constantize.send(:perform_now)
  rescue StandardError => e
    puts("Couldn't enqueue job", e)
  end
end
