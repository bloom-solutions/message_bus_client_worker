module MessageBusClientWorker
  module Polling
    class GetLastId

      def self.call(host, channel, headers: {})
        hash_key = GenLastIdKey.(host: host, channel: channel, headers: headers)
        Sidekiq.redis { |r| r.hget(SetLastId::CHANNEL_INDICES_NAME, hash_key) }
      end

    end
  end
end
