# frozen_string_literal: true

source("https://rubygems.org")
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby("3.1.2")

gem("rails", "6.1.7.2")

gem("google-cloud-pubsub")
gem("pry-rails")
gem("puma")
gem("sqlite3")

group(:development, :test) do
  gem("pry-byebug")
  gem("rubocop")
end

group(:development) do
  gem("listen")
end
