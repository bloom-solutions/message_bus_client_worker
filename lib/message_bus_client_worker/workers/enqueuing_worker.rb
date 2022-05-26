module MessageBusClientWorker
  class EnqueuingWorker

    include ::Sidekiq::Worker
    sidekiq_options retry: false

    def perform
      MessageBusClientWorker.configuration.subscriptions.each do |host, subs|
        SubscriptionWorker.perform_async(host, subs.to_json)
      end
    end

  end
end
