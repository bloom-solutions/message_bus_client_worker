module MessageBusClientWorker
  module Polling
    class GetPayloads
      extend LightService::Action

      expects :params, :form_params, :uri
      promises :payloads

      executed do |c|
        response = Excon.post(c.uri, {
          query: c.params,
          body: URI.encode_www_form(c.form_params)
        })
        c.payloads = JSON.parse(response.body.to_s)
      end
    end
  end
end
