module MessageBusClientWorker
  class EnqueuingWorker

    include ::Sidekiq::Worker
    sidekiq_options retry: false

    def perform
      Rails.logger.info "Will enqueue all of `#{MessageBusClientWorker.configuration}`"
      MessageBusClientWorker.configuration.subscriptions.each do |host, subs|
        Rails.logger.info "Calling `SubscriptionWorker.perform_async(#{host}, #{subs.inspect})`"
        SubscriptionWorker.perform_async(host, subs)
      end
    end

  end
end
