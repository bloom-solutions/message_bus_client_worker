module MessageBusClientWorker
  module Polling
    class GetPayloads
      extend LightService::Action

      expects :params, :form_params, :uri, :headers
      promises :payloads

      executed do |c|
        opts = {
          query: c.params,
          body: URI.encode_www_form(c.form_params),
        }

        opts.merge!(headers: c.headers) if c.headers
        response = Excon.post(c.uri, opts)

        c.payloads = JSON.parse(response.body.to_s)
      end
    end
  end
end
