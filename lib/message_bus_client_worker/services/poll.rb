module MessageBusClientWorker
  class Poll

    extend LightService::Organizer

    def self.call(host, channel, processor_class_name, long)
      with(
        host: host,
        channel: channel,
        processor_class_name: processor_class_name,
        long: long,
      ).reduce(
        SubscriptionWorkers::GenerateClientId,
        SubscriptionWorkers::GenerateURI,
        SubscriptionWorkers::SetChannelIndices,
        SubscriptionWorkers::GenerateParams,
        SubscriptionWorkers::GetMessages,
        SubscriptionWorkers::GetProcessor,
        SubscriptionWorkers::ProcessMessages,
      )
    end

  end
end
