# frozen_string_literal: true

class HelloKisiJob < ActiveJob::Base
  queue_as(:default)
  retry_on(StandardError, wait: 5.minutes, attempts: 2)

  def perform(*_args)
    puts("Hello Kisi")
  end
end
