# frozen_string_literal: true

require("test_helper")

class PubsubAdapterTest < Minitest::Test
  def setup
    @job = HelloKisiJob.new
    @adapter = ActiveJob::Base.queue_adapter
    @client = Minitest::Mock.new
    @adapter.enqueued_jobs = []
    Rails.application.config.pubsub_client = @client
    @client.expect(:publish, true, [@job.class.to_s])
  end

  def test_that_enqueues_job
    assert_equal(0, @adapter.enqueued_jobs.length)
    @adapter.enqueue(@job)
    assert_equal(1, @adapter.enqueued_jobs.length)
    @client.verify
  end

  def test_enqueued_at
    assert_equal(0, @adapter.enqueued_jobs.length)
    @adapter.enqueue_at(@job, Time.current.to_f + 0.5)
    assert_equal(1, @adapter.enqueued_jobs.length)
    @client.verify
  end
end
