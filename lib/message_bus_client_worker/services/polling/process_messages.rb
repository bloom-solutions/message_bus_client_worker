module MessageBusClientWorker
  module Polling
    class ProcessMessages
      extend LightService::Action

      expects :host, :channel, :messages, :processor_class, :channel_indices_name

      executed do |c|
        c.messages.each do |message|
          set_last_id_in_redis(
            host: c.host,
            channel: c.channel,
            message: message,
            redis_channel: c.channel_indices_name
          )
          c.processor_class.(message["data"])
        end
      end

      def self.set_last_id_in_redis(host:, channel:, message:, redis_channel:)
        hash_key = "#{host}-#{channel}"
        message_id = message["message_id"]

        Sidekiq.redis do |r|
          r.hset(redis_channel, hash_key, message_id)
        end
      end
    end
  end
end
