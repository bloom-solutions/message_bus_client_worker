require "addressable"
require "gem_config"
require "http"
require "light-service"
require "securerandom"
require "sidekiq"
require "sidekiq-unique-jobs"
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
    has :subscriptions, classes: Hash
  end

  def self.config_sidekiq!
    Sidekiq.configure_server do |config|
      config.death_handlers << ->(job, _ex) do
        return unless job['unique_digest']
        SidekiqUniqueJobs::Digests.del(digest: job['unique_digest'])
      end
    end
  end

end

MessageBusClientWorker.config_sidekiq!
