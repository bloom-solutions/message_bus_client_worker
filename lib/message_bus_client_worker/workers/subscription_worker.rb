module MessageBusClientWorker
  class SubscriptionWorker

    include Sidekiq::Worker
    sidekiq_options retry: 0

    def perform(host, subscriptions_json, long = false)
      subscriptions = JSON.parse(subscriptions_json).with_indifferent_access

      log(host, subscriptions)
      Poll.call(host, subscriptions, long)
    end

    private

    def log(host, subscriptions)
      subscriptions[:channels].each do |channel, _|
        logger.info "Enqueued #{host} for #{channel}"
      end
    end

    def self.unique_args(args)
      args
    end

  end
end
