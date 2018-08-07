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
        Polling::GenerateClientId,
        Polling::GenerateURI,
        Polling::SetChannelIndices,
        Polling::GenerateParams,
        Polling::GetMessages,
        Polling::GetProcessor,
        Polling::ProcessMessages,
      )
    end

  end
end
