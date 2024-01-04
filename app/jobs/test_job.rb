class TestJob < ApplicationJob
  def perform(data)
    raise("Fake Failure") if rand < 0.2 # 20% chance of failure

    # Job time duration
    sleep_duration = rand(5)
    sleep(sleep_duration)

    p("Processed data: #{data}, Sleep Duration: #{sleep_duration}s")
  end
end
