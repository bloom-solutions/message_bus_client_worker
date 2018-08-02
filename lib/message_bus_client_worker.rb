require "addressable"
require "gem_config"
require "http"
require "securerandom"
require "sidekiq"
require "message_bus_client_worker/version"
require "message_bus_client_worker/workers/enqueuing_worker"
require "message_bus_client_worker/workers/subscription_worker"

module MessageBusClientWorker

  include GemConfig::Base

  with_configuration do
    has :subscriptions, classes: Hash
  end

end
