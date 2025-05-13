FROM ruby:3.3.5

WORKDIR /usr/src/app
COPY Gemfile* ./

RUN gem install bundler --conservative
RUN bundle install

COPY . .

EXPOSE 3000
