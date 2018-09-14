module MessageBusClientWorker
  class SubscriptionWorker

    include Sidekiq::Worker
    sidekiq_options(
      retry: false,
      lock: :until_executed,
      unique_args: :unique_args,
    )

    def perform(host, subscriptions, long=false)
      Poll.(host, subscriptions.with_indifferent_access, long)
    end

    def self.unique_args(*args)
      [args.first]
    end

  end
end

