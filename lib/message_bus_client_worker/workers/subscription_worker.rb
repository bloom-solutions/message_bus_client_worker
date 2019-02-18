module MessageBusClientWorker
  class SubscriptionWorker

    include Sidekiq::Worker
    sidekiq_options retry: 0

    def perform(host, subscriptions, long = false)
      log(host, subscriptions.with_indifferent_access)
      Poll.call(host, subscriptions.with_indifferent_access, long)
    end

    private

    def log(host, subscriptions)
      subscriptions[:channels].each do |channel, _|
        Sidekiq::Logging.logger.info "Enqueued #{host} for #{channel}"
      end
    end

    def self.unique_args(args)
      args
    end

  end
end
