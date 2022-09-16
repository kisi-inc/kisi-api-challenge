class SecondJob < ApplicationJob

  def perform(args)
    puts "The message #{args} was publish in Second-Job topic"
  end

end
