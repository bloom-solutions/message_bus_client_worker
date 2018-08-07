module MessageBusClientWorker
  class Poll

    extend LightService::Organizer

    def self.call(host, subscriptions, long)
      with(
        host: host,
        subscriptions: subscriptions,
        long: long,
      ).reduce(
        Polling::GenerateClientId,
        Polling::GenerateURI,
        Polling::GenerateParams,
        Polling::GetMessages,
        Polling::ProcessMessages,
      )
    end

  end
end
