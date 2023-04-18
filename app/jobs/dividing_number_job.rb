class DividingNumberJob < ApplicationJob
  queue_as :default

  before_enqueue { |job| puts "#{job.class.name}.enqueue - #{job.arguments}" }

  rescue_from(ZeroDivisionError) do |exception|
    puts "Exception: #{exception}"
  end

  def perform(a, b)
    # Do something later
    r = a/b
    puts "Dividing two number: #{a}/#{b} = #{r}"
  end
end
