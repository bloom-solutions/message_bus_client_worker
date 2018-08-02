FROM ruby:2.5.1

WORKDIR /gem

ENV BUNDLE_GEMFILE=/gem/Gemfile \
  BUNDLE_JOBS=2 \
  BUNDLE_PATH=/bundle

COPY Gemfile Gemfile.lock message_bus_client_worker.gemspec /gem/
COPY lib/message_bus_client_worker/version.rb /gem/lib/message_bus_client_worker/

RUN gem install bundler --no-ri --no-rdoc && \
  bundle install --jobs 20 --retry 5

COPY . /gem
