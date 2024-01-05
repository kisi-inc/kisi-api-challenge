# frozen_string_literal: true

require("google/cloud/pubsub")

class Pubsub
  def self.client
    @client ||= Google::Cloud::PubSub.new(project_id: "kisi-code-challenge")
  end

  # Find or create a topic.
  #
  # @param topic [String] The name of the topic to find or create
  # @return [Google::Cloud::PubSub::Topic]
  def self.topic(name)
    client.topic(name) || client.create_topic(name)
  end

  def self.publish(topic_name, message)
    topic = topic(topic_name)
    topic.publish(message)
  end

  def self.subscribe(subscription_name)
    client.subscription(subscription_name)
  end

  # Create a new client.
  #
  # @return [Google::Cloud::PubSub]
  # def client
  #   @client ||= Google::Cloud::PubSub.new(project_id: "kisi-code-challenge")
  # end
end
