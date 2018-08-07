module MessageBusClientWorker
  module Polling
    class GenerateParams
      extend LightService::Action

      CHANNEL_INDICES_NAME = "message_bus_client_worker_channel_indices".freeze
      expects :host, :subscriptions
      promises :params, :form_params

      executed do |c|
        c.params = { dlp: 't' }
        c.form_params = c.subscriptions.each_with_object({}) do |sub, hash|
          hash[sub[0]] = get_last_id_from_redis(
            host: c.host,
            channel: sub[0],
          )
        end
      end

      def self.get_last_id_from_redis(host:, channel:)
        hash_key = GenLastIdKey.(host, channel)

        id = Sidekiq.redis do |r|
          r.hget(CHANNEL_INDICES_NAME, hash_key)
        end

        id || "0"
      end
    end
  end
end
