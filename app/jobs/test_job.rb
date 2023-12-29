class TestJob < ApplicationJob

  def perform(data)
    p data
  end
end
