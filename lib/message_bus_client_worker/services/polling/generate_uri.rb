module MessageBusClientWorker
  module Polling
    class GenerateURI
      extend LightService::Action

      expects :host, :client_id
      promises :uri

      executed do |c|
        uri = Addressable::URI.parse(c.host)
        uri.path = "/message-bus/#{c.client_id}/poll"
        c.uri = uri.to_s
      end
    end
  end
end
