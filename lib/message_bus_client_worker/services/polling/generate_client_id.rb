module MessageBusClientWorker
  module Polling
    class GenerateClientId
      extend LightService::Action

      promises :client_id

      executed do |c|
        c.client_id = client_id = MessageBusClientWorker.configuration.client_id
        c.client_id = client_id.() if client_id.respond_to?(:call)
      end
    end
  end
end
