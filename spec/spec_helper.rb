require "bundler/setup"
require "message_bus_client_worker"
require "rspec-sidekiq"
require "pathname"
require "pry-byebug"
require "yaml"
require "wait"
require "active_support/core_ext/hash/indifferent_access"

SPEC_DIR = Pathname.new(File.dirname(__FILE__))

require SPEC_DIR.join("fixtures/test_proc")

Dir[SPEC_DIR.join("support/**.rb")].each { |f| require f }

CONFIG_YAML = SPEC_DIR.join("config.yml")
CONFIG = YAML.load_file(CONFIG_YAML).with_indifferent_access

REDIS = Redis.new(url: CONFIG[:redis_url])

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before :suite do
    # Wait until Redis is ready
    Wait.new.until do
      REDIS.set("booted", "yep")
      REDIS.get("booted") == "yep"
    end
  end
end
