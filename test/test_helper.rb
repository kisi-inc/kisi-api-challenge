# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
ENV["PUBSUB_EMULATOR_HOST"] = "localhost:8681"

require_relative("../config/environment")
require("rails/test_help")
require("minitest/autorun")

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Add more helper methods to be used by all tests here...

    def setup
      (ActiveJob::Base.descendants << ActiveJob::Base).each(&:disable_test_adapter)
      ActiveJob::Base.queue_adapter = ActiveJob::QueueAdapters::PubsubAdapter.new
    end
  end
end
