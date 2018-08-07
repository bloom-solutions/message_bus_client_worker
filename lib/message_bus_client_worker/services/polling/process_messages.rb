module MessageBusClientWorker
  module Polling
    class ProcessMessages
      extend LightService::Action

      expects :host, :subscriptions, :messages

      executed do |c|
        c.messages.each do |message|
          channel = message["channel"]

          processor_class = Kernel.const_get(
            c.subscriptions[channel][:processor]
          )

          SetLastId.(c.host, channel, message["message_id"])
          processor_class.(message["data"], message)
        end
      end

    end
  end
end
