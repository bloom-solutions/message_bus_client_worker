module MessageBusClientWorker
  module Polling
    class GetLastId

      def self.call(host, channel)
        hash_key = GenLastIdKey.(host, channel)
        Sidekiq.redis { |r| r.hget(SetLastId::CHANNEL_INDICES_NAME, hash_key) }
      end

    end
  end
end
