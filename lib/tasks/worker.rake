# frozen_string_literal: true

namespace(:worker) do
  desc("Run the worker")
  task(run: :environment) do
    puts("Worker starting...")
    @pubsub = Pubsub.new
    @queue_name  = "default"
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
