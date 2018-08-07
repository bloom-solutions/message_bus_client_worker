module MessageBusClientWorker
  class SubscriptionWorker

    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(host, subscriptions, long=false)
      Poll.(host, subscriptions, long)
    end

  end
end

