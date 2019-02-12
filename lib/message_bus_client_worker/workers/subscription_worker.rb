module MessageBusClientWorker
  class SubscriptionWorker

    include Sidekiq::Worker
    sidekiq_options retry: 0

    def perform(host, subscriptions, long = false)
      log(host, subscriptions)
      Poll.call(host, subscriptions.with_indifferent_access, long)
    end

    private

    def log(host, subscriptions)
      subscriptions.each do |key, subscription|
        Sidekiq::Logging.logger.info "Enqueued #{host} for #{subscription[:channels]}"
      end
    end

    def self.unique_args(args)
      args
    end

  end
end
