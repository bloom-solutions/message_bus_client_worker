module MessageBusClientWorker
  module Polling
    class SetLastId

      CHANNEL_INDICES_NAME = "message_bus_client_worker_channel_indices".freeze
      def self.call(host:, channel:, message_id:, headers:)
        hash_key = GenLastIdKey.(host: host, channel: channel, headers: headers)

        id = Sidekiq.redis do |r|
          r.hset(CHANNEL_INDICES_NAME, hash_key, message_id)
        end

        id || "0"
      end

    end
  end
end
