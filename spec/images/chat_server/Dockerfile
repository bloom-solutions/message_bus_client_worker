FROM ruby:2.5.1

WORKDIR /app

ENV BUNDLE_GEMFILE=/app/Gemfile \
  BUNDLE_JOBS=2 \
  BUNDLE_PATH=/bundle

COPY Gemfile Gemfile.lock /app/

RUN gem install bundler --no-ri --no-rdoc && \
  bundle install --jobs 20 --retry 5

COPY . /app
