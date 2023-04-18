class HelloWorldJob < ApplicationJob
  # queue_as :pubsub
  # self.queue_adapter = :pubsub

  before_enqueue { |job| puts "#{job.class.name}.enqueue" }

  def perform(*args)
    # Do something later
    puts "Greeting from Hello World JOB !!!"
  end
end
