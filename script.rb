# Load Testing Script
def enqueue_test_jobs
  5.times do |i|
    data = { count: i, timestamp: Time.now }

    TestJob.perform_later(data)

    # Sleep for 0.2 seconds to achieve a rate of 5 jobs per second
    sleep(0.2)
  end
end

# Run the load test for a certain duration
end_time = Time.now + 5 # 5 seconds from now
enqueue_test_jobs while Time.now < end_time
