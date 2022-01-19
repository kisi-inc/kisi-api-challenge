# frozen_string_literal: true

source("https://rubygems.org")
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby("2.7.5")

gem("puma", "~> 5.0")
gem("rails", "~> 6.1.4", ">= 6.1.4.4")
gem("rubocop")
gem("sqlite3", "~> 1.4")

group(:development, :test) do
  gem("byebug", platforms: %i[mri mingw x64_mingw])
end

group(:development) do
  gem("listen", "~> 3.3")
end
