module MessageBusClientWorker
  module Polling
    class GetLastId

      def self.call(host, channel)
        hash_key = GenLastIdKey.(host, channel)

        id = Sidekiq.redis do |r|
          r.hget(SetLastId::CHANNEL_INDICES_NAME, hash_key)
        end

        id || "0"
      end

    end
  end
end
