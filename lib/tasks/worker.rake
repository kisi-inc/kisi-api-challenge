# frozen_string_literal: true

namespace(:worker) do
  desc("Run the worker")
  task(run: :environment) do
    load_data
    @pubsub = Pubsub.new
    @queue_name = "default"
    max_deadline = 10
    subscriber = @pubsub.subscription(@queue_name).listen(deadline: max_deadline) do |message|
      puts("message with id: #{message.message_id} received")
      deadline = @pubsub.fetch_message_delay(message)
      process(message) if deadline <= 0
    end
    subscriber.start
    sleep
  end

  def process(message)
    Concurrent::Promise.execute(args: message, executor: :io) do |msg|
      ApplicationJob.execute(JSON.parse(msg.data))
      message.acknowledge!
    rescue StandardError => e
      message.acknowledge!
      @pubsub.topic("dead_letter_topic").publish(message)
      puts(e.message)
      Rails.logger.error(e)
    end
  end
end

def load_data
  puts("Make Some Load...")
  HelloWorldWorker.set(wait: 5.seconds).perform_later
  HelloWorldWorker.set(wait: 5.seconds).perform_later
  HelloWorldWorker.set(wait: 5.seconds).perform_later
  FailedHelloWorldWorker.set(wait: 5.seconds).perform_later
  FailedHelloWorldWorker.set(wait: 5.seconds).perform_later
end
