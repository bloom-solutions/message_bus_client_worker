module MessageBusClientWorker
  class SubscriptionWorker

    include Sidekiq::Worker
    sidekiq_options retry: false

    CHANNEL_INDICES_REDIS_HASH_NAME = "message_bus_client_worker_channel_indices"

    def perform(host, channel, processor_class_name, long=true)
      client_id = SecureRandom.uuid
      uri = Addressable::URI.parse(host)
      uri.path = "/message-bus/#{client_id}/poll"

      params = {dlp: "t"}
      form_params = {
        channel => get_last_id_from_redis(host: host, channel: channel)
      }
      body = HTTP.post(uri.to_s, params: params, form: form_params).body

      messages = JSON.parse(body.to_s)
      processor_class = Kernel.const_get(processor_class_name)

      messages.each do |message|
        set_last_id_in_redis(host: host, channel: channel, message: message)
        processor_class.(message["data"])
      end
    end

    def set_last_id_in_redis(host:, channel:, message:)
      hash_key = "#{host}-#{channel}"
      message_id = message["message_id"]

      Sidekiq.redis do |r|
        r.hset(CHANNEL_INDICES_REDIS_HASH_NAME, hash_key, message_id)
      end
    end

    def get_last_id_from_redis(host:, channel:)
      hash_key = "#{host}-#{channel}"

      id = Sidekiq.redis do |r|
        r.hget(CHANNEL_INDICES_REDIS_HASH_NAME, hash_key)
      end

      if id.to_i == -1
        '0'
      else
        id
      end
    end
  end
end
