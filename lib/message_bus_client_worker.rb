require "gem_config"
require "message_bus_client_worker/version"

module MessageBusClientWorker

  include GemConfig::Base

  with_configuration do
    has :subscriptions, classes: Hash
  end

end
