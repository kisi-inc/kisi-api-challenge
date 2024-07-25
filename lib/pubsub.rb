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

  private

  # Create a new client.
  #
  # @return [Google::Cloud::PubSub]
  def client
    @client ||= Google::Cloud::PubSub.new(project_id: "code-challenge")
  end

  def self.publish(message, topic_name = 'jobs')
    topic(topic_name).publish(message)
  end

  def self.pull_messages(subscription_name)
    subscription = client.subscription(subscription_name)
    subscriber = subscription.listen do |received_message|
      yield(received_message.data)
      received_message.acknowledge!
    end
    subscriber.start
    sleep
  end
end
