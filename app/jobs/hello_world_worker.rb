# frozen_string_literal: true

class HelloWorldWorker < ApplicationJob
  def perform
    sleep(3.seconds)
    puts("hello, I am a worker")
  end
end
