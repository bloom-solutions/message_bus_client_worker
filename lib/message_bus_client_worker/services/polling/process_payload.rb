module MessageBusClientWorker
  module Polling
    class ProcessPayload
      extend LightService::Action

      expects :host, :subscriptions, :payload

      executed do |c|
        payload = c.payload
        channel = payload["channel"]
        channel_config = c.subscriptions[channel]

        next c if channel_config.nil?

        processor_class = Kernel.const_get(channel_config[:processor])

        SetLastId.(c.host, channel, payload["message_id"])
        processor_class.(payload["data"], payload)
      end

    end
  end
end
