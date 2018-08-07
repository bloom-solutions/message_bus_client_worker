module MessageBusClientWorker
  class SubscriptionWorker

    include Sidekiq::Worker
    sidekiq_options retry: false, lock: :until_executed

    def perform(host, subscriptions, long=false)
      Poll.(host, subscriptions.with_indifferent_access, long)
    end

  end
end

