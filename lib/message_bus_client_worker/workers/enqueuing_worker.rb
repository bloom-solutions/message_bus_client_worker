module MessageBusClientWorker
  class EnqueuingWorker

    include ::Sidekiq::Worker
    sidekiq_options retry: false

    def perform
      MessageBusClientWorker.configuration.subscriptions.each do |host, subs|
        subs.each do |channel, processor|
          SubscriptionWorker.perform_async(host, channel, processor)
        end
      end
    end

  end
end
