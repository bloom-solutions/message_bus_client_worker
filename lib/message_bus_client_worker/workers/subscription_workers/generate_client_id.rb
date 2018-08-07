module MessageBusClientWorker
  module SubscriptionWorkers
    class GenerateClientId
      extend LightService::Action

      promises :client_id

      executed do |c|
        c.client_id = SecureRandom.uuid
      end
    end
  end
end
