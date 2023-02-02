# frozen_string_literal: true

namespace(:worker) do
  desc("Run the worker")
  task(run: :environment) do
    # See https://googleapis.dev/ruby/google-cloud-pubsub/latest/index.html

    puts("Worker starting...")

    # Block, letting processing threads continue in the background
    pubsub = PubSub.new.client()
    subscription = pubsub.subscription("challenge")
    subscription.listen do |message|
      job = ActiveJob::DeserializationError.wrap(message) do
        ActiveJob::Base.deserialize(message.data)
      end
      job.perform_now
      message.acknowledge!
    end
  end
end
