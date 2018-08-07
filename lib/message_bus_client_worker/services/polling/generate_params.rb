module MessageBusClientWorker
  module Polling
    class GenerateParams
      extend LightService::Action

      expects :host, :channel, :channel_indices_name
      promises :params, :form_params

      executed do |c|
        c.params = { dlp: 't' }
        c.form_params = {
          c.channel => get_last_id_from_redis(
            host: c.host,
            channel: c.channel,
            redis_channel: c.channel_indices_name
          )
        }
      end

      def self.get_last_id_from_redis(host:, channel:, redis_channel:)
        hash_key = "#{host}-#{channel}"

        id = Sidekiq.redis do |r|
          r.hget(redis_channel, hash_key)
        end

        return '0' if id.nil?
        id
      end
    end
  end
end
