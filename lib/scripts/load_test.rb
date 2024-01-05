# To run the script, use:
# docker-compose exec web bin/rails runner -e development "require './lib/load_test'; LoadTest.run(60)"
# Replace '60' with the desired duration in seconds for continuously running the jobs.

module LoadTest
  def self.run(duration_in_seconds)
    end_time = Time.now + duration_in_seconds

    while Time.now < end_time
      5.times do |i|
        data = { count: i, timestamp: Time.now.to_f }
        TestJob.perform_later(data)
        sleep(0.2) # Sleep for 0.2 seconds to achieve a rate of 5 jobs per second
      end
    end
  end
end
