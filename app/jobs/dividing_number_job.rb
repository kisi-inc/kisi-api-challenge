class DividingNumberJob < ApplicationJob
  queue_as :default

  before_enqueue { |job| puts "#{job.class.name}.enqueue - #{job.arguments}" }

  retry_on ZeroDivisionError, wait: 5.seconds, attempts: 4

  def perform(a, b)
    # Do something later
    r = a/b
    puts "Dividing two number: #{a}/#{b} = #{r}"
  end
end
