module MessageBusClientWorker
  class SubscriptionWorker

    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(host, channel, processor, long=false)
      Poll.(host, channel, processor, long)
    end

  end
end

