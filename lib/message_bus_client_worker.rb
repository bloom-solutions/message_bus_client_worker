require "addressable"
require "digest"
require "excon"
require "gem_config"
require "light-service"
require "securerandom"
require "sidekiq"
require "securerandom"
require "active_support/core_ext/hash/indifferent_access"
require "active_support/core_ext/string/inflections"
require "message_bus_client_worker/version"
require "message_bus_client_worker/workers/enqueuing_worker"
require "message_bus_client_worker/workers/subscription_worker"
require "message_bus_client_worker/services/polling/gen_last_id_key"
require "message_bus_client_worker/services/polling/get_last_id"
require "message_bus_client_worker/services/polling/set_last_id"
require "message_bus_client_worker/services/polling/generate_client_id"
require "message_bus_client_worker/services/polling/generate_uri"
require "message_bus_client_worker/services/polling/generate_params"
require "message_bus_client_worker/services/polling/get_payloads"
require "message_bus_client_worker/services/polling/process_payload"
require "message_bus_client_worker/services/poll"

module MessageBusClientWorker

  include GemConfig::Base

  with_configuration do
    has :subscriptions, classes: [Hash, NilClass]
    has :client_id, classes: [Proc, String], default: -> {SecureRandom.uuid}
  end

  def self.subscribe(host, options)
    self.configuration.subscriptions ||= {}

    if self.configuration.subscriptions.keys.include?(host)
      warn "[#{self.name}] #{host} already configured, overwriting (called from #{caller.first})"
    end

    self.configuration.subscriptions[host] = options
  end

end
