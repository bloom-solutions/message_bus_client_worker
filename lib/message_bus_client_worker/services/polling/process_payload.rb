module MessageBusClientWorker
  module Polling
    class ProcessPayload
      extend LightService::Action

      expects(
        :host, 
        :subscriptions, 
        :payload, 
        :headers
      )

      TWO_ARGS   = 2
      THREE_ARGS = 3

      executed do |c|
        payload = c.payload
        channel = payload["channel"]
        channel_config = c.subscriptions[:channels][channel]

        next c if channel_config.nil?

        processor_class = Kernel.const_get(channel_config[:processor])
        SetLastId.(
          host: c.host,
          channel: channel,
          message_id: payload["message_id"],
          headers: c.headers,
        )

        data = payload["data"]

        case processor_class.method(:call).arity
        when TWO_ARGS
          processor_class.(data, payload)
        when THREE_ARGS
          processor_class.(data, payload, c.headers)
        else
          processor_class.(data)
        end
      end

    end
  end
end
