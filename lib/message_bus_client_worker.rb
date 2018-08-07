require "addressable"
require "gem_config"
require "http"
require "light-service"
require "securerandom"
require "sidekiq"
require "message_bus_client_worker/version"
require "message_bus_client_worker/workers/enqueuing_worker"
require "message_bus_client_worker/workers/subscription_worker"
require "message_bus_client_worker/services/polling/gen_last_id_key"
require "message_bus_client_worker/services/polling/generate_client_id"
require "message_bus_client_worker/services/polling/generate_uri"
require "message_bus_client_worker/services/polling/generate_params"
require "message_bus_client_worker/services/polling/get_messages"
require "message_bus_client_worker/services/polling/process_messages"
require "message_bus_client_worker/services/poll"

module MessageBusClientWorker

  include GemConfig::Base

  with_configuration do
    has :subscriptions, classes: Hash
  end

end
