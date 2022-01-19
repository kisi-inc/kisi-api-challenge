FROM ruby:2.7.5

WORKDIR /usr/src/app
COPY Gemfile* ./

RUN gem install bundler --conservative
RUN bundle install

COPY . .

EXPOSE 3000
