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
      Rails.logger.info "SubscriptionWorker got work for #{host} / #{subscriptions.inspect}"
      Poll.(host, subscriptions.with_indifferent_access, long)
    end

    def self.unique_args(*args)
      [args.first]
    end

  end
end

