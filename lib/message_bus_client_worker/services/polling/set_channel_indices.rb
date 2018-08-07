module MessageBusClientWorker
  module Polling
    class SetChannelIndices
      extend LightService::Action

      promises :channel_indices_name

      executed do |c|
        c.channel_indices_name = 'message_bus_client_worker_channel_indices'
      end
    end
  end
end
