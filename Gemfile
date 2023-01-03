# frozen_string_literal: true

source("https://rubygems.org")
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby("3.1.2")

gem("google-cloud-pubsub")
gem("pry-rails")
gem("puma")
gem("rails")
gem("rubocop")
gem("sqlite3")

group(:development, :test) do
  gem("byebug", platforms: %i[mri mingw x64_mingw])
end

group(:development) do
  gem("listen")
end
