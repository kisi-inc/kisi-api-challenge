# frozen_string_literal: true

require("google/cloud/pubsub")

class Pubsub
  # Find or create a topic.
  #
  # @param topic [String] The name of the topic to find or create
  # @return [Google::Cloud::PubSub::Topic]
  def topic(name)
    client.topic(name) || client.create_topic(name)
  end

  # Find or create a subscription.
  #
  # @param topic [Google::Cloud::PubSub::Topic] The topic
  # @param subscription [String] The name of the subscription to find or create
  # @return [Google::Cloud::PubSub::Subscription]
  def subscription(topic, subscription)
    topic.subscription(subscription) || topic.subscribe(subscription)
  end

  # Publish a message to a topic.
  #
  # @param topic [Google::Cloud::PubSub::Topic] The topic
  # @param message [String] The message to publish
  # @return [Google::Cloud::PubSub::Message]
  def publish(topic, message)
    topic.publish(message)
  end

  private

  # Create a new client.
  #
  # @return [Google::Cloud::PubSub]
  def client
    @client ||= Google::Cloud::PubSub.new(project_id: "code-challenge")
  end
end
