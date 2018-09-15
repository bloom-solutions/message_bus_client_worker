module MessageBusClientWorker
  class SubscriptionWorker

    include Sidekiq::Worker
    sidekiq_options(
      retry: false,
      lock: :until_executed,
      unique_args: :unique_args,
      on_conflict: :log,
    )

    def perform(host, subscriptions, long=false)
      Poll.(host, subscriptions.with_indifferent_access, long)
    end

    def self.unique_args(args)
      args
    end

  end
end

