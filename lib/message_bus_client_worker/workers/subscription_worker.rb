module MessageBusClientWorker
  class SubscriptionWorker

    include Sidekiq::Worker
    sidekiq_options(
      retry: false,
      # lock: :until_executed,
      # unique_args: :unique_args,
      # on_conflict: :log,
    )

    def perform(host, subscriptions, long = false)
      log(host, subscriptions)
      Poll.call(host, subscriptions.with_indifferent_access, long)
    end

    private

    def log(host, subscriptions)
      subscriptions.each do |subscription|
        Sidekiq::Logging.logger.info "Enqueued #{host} for #{subscription}"
      end
    end

    # def self.unique_args(args)
    #   args
    # end

  end
end
