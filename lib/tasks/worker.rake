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
      data = JSON.parse(received_message.message.data)
      ActiveJob::Base.execute data

      puts "End...!!!"
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

  desc("Run the Divider Job")
  task :division, [:a, :b] => [:environment] do |t, args|
    puts("Running division.... #{args[:a]} - #{args[:b]}")

    DividingNumberJob.perform_later(args[:a].to_f, args[:b].to_f)
  end

end
