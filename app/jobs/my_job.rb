class MyJob < ApplicationJob
  queue_as :default

  def perform
    puts "hello world"
  end
end