class FirstJob < ApplicationJob

  def perform(args)
    puts "The message #{args} was publish in First-Job topic"
  end

end