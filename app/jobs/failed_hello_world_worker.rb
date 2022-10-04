# frozen_string_literal: true

class FailedHelloWorldWorker < ApplicationJob
  def perform
    puts("I am inside the failed worker")
    raise("I am failed now")
  end
end
