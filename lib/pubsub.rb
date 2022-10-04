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
  # @param subscription_id [String] The name of the topic to subscribe on
  # @return [Google::Cloud::PubSub::Subscription]
  def subscription(topic)
    name = "worker-#{topic}"
    client.subscription(name) || topic(topic).subscribe(name, enable_exactly_once_delivery: true,
                                                              dead_letter_topic: dead_letter_topic,
                                                              dead_letter_max_delivery_attempts: 2)
  end

  # create dead letter topic to keep track of dead jobs that failed after all retry attempts
  def dead_letter_topic
    topic("dead_letter_topic")
  end

  # to help checking if message should be processing now, or should be delayed
  def fetch_message_delay(message)
    timestamp = message_timestamp(message)
    return 0 unless timestamp

    (timestamp - Time.current.to_f).to_f
  end

  def retry_policy
    retry_policy ||= Google::Cloud::PubSub::RetryPolicy.new(minimum_backoff: 300, maximum_backoff: 600)
    retry_policy
  end

  private

  # Create a new client.
  #
  # @return [Google::Cloud::PubSub]
  def client
    @client ||= Google::Cloud::PubSub.new(project_id: "code-challenge")
  end

  # fetches message timestamp from attributes
  def message_timestamp(message)
    timestamp = message.attributes["timestamp"]
    return nil unless timestamp

    Time.at(timestamp.to_f)
  end
end
