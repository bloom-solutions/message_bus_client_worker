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
        execute(->(c) { c[:headers] = c[:subscriptions][:headers] }),
        Polling::GenerateParams,
        Polling::GetPayloads,
        iterate(:payloads, [
          Polling::ProcessPayload,
        ])
      )
    end

  end
end
