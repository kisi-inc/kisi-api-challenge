# frozen_string_literal: true

require("test_helper")

class HelloKisiJobTest < ActiveJob::TestCase
  setup do
    @client = Minitest::Mock.new
    Rails.application.config.pubsub_client = @client
    @client.expect(:publish, true, [String])
  end

  test("that job is enqueued") do
    assert_enqueued_jobs(0)
    HelloKisiJob.perform_later
    assert_enqueued_jobs(1)
  end

  test("that job is using correct queue adapter") do
    assert_instance_of(ActiveJob::QueueAdapters::PubsubAdapter, HelloKisiJob.queue_adapter)
  end
end
