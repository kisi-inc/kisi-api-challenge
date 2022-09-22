# frozen_string_literal: true

require("test_helper")

class PubsubTest < Minitest::Test
  def setup
    @client = Pubsub.new("test-topic", "test-topic-sub")
  end

  def test_that_creates_topic
    new_topic = @client.topic("new-topic")
    assert_instance_of(Google::Cloud::PubSub::Topic, new_topic)
  end

  def test_that_finds_topic
    old_topic = @client.topic("test-topic")
    assert_instance_of(Google::Cloud::PubSub::Topic, old_topic)
  end

  def test_that_creates_subscription
    subscription = @client.subscription
    assert_instance_of(Google::Cloud::PubSub::Subscription, subscription)
  end

  def test_that_publishes_message
    topic = @client.topic("new-topic")
    message = topic.publish("new message")
    assert_instance_of(Google::Cloud::PubSub::Message, message)
  end
end
