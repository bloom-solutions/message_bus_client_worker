FROM ruby:2.6.3

WORKDIR /app

ENV BUNDLE_GEMFILE=/app/Gemfile \
  BUNDLE_JOBS=2 \
  BUNDLE_PATH=/bundle

COPY Gemfile Gemfile.lock /app/

RUN gem install bundler && \
  bundle install --jobs 20 --retry 5

COPY . /app
