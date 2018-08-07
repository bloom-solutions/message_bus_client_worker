module MessageBusClientWorker
  module Polling
    class SetLastId

      def self.call(host, channel, message_id)
        hash_key = GenLastIdKey.(host, channel)

        id = Sidekiq.redis do |r|
          r.hset(GenerateParams::CHANNEL_INDICES_NAME, hash_key, message_id)
        end

        id || "0"
      end

    end
  end
end
