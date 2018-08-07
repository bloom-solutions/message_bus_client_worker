module MessageBusClientWorker
  module Polling
    class ProcessMessages
      extend LightService::Action

      expects :host, :subscriptions, :messages

      executed do |c|
        c.messages.each do |message|
          channel = message["channel"]
          processor_class = Kernel.const_get(c.subscriptions[channel])

          set_last_id_in_redis(
            host: c.host,
            channel: channel,
            message_id: message["message_id"],
          )
          processor_class.(message["data"])
        end
      end

      def self.set_last_id_in_redis(host:, channel:, message_id:)
        hash_key = "#{host}-#{channel}"

        Sidekiq.redis do |r|
          r.hset(GenerateParams::CHANNEL_INDICES_NAME, hash_key, message_id)
        end
      end
    end
  end
end
