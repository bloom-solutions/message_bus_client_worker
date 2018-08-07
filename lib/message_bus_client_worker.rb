require "addressable"
require "gem_config"
require "http"
require "light-service"
require "securerandom"
require "sidekiq"
require "message_bus_client_worker/version"
require "message_bus_client_worker/workers/enqueuing_worker"
require "message_bus_client_worker/workers/subscription_worker"
require "message_bus_client_worker/workers/subscription_workers/generate_client_id"
require "message_bus_client_worker/workers/subscription_workers/generate_uri"
require "message_bus_client_worker/workers/subscription_workers/set_channel_indices"
require "message_bus_client_worker/workers/subscription_workers/generate_params"
require "message_bus_client_worker/workers/subscription_workers/get_messages"
require "message_bus_client_worker/workers/subscription_workers/get_processor"
require "message_bus_client_worker/workers/subscription_workers/process_messages"

module MessageBusClientWorker

  include GemConfig::Base

  with_configuration do
    has :subscriptions, classes: Hash
  end

end
