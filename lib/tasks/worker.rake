# frozen_string_literal: true

namespace(:worker) do
  desc("Run the worker")
  task(run: :environment) do
    # See https://googleapis.dev/ruby/google-cloud-pubsub/latest/index.html

    puts("Worker starting...")

    puts("Pubsub New: #{Pubsub.new.subscription("default") == nil}")
    sub = Pubsub.new.subscription("default")
    subscriber = sub.listen do |received_message|
      # process message
      puts "Data: #{received_message.message.data}"
      puts "Published at #{received_message.message.published_at}"
      puts

      job = received_message.message.data.constantize
      puts "Job : #{job}"
      puts

      job.perform_now

      received_message.acknowledge!
    end

    subscriber.on_error do |exception|
      puts "Exception: #{exeception.class} #{exception.message}"
    end

    at_exit do
      subscriber.stop!(10)
    end

    subscriber.start

    # Block, letting processing threads continue in the background
    sleep
  end

  desc("Run the Hello world Job")
  task(hello: :environment) do
    puts("Running hello....")

    HelloWorldJob.perform_later
  end

end
