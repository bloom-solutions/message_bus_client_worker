module MessageBusClientWorker
  module Polling
    class GetPayloads
      extend LightService::Action

      expects :params, :form_params, :uri
      promises :payloads

      executed do |c|
        body = HTTP.post(c.uri, params: c.params, form: c.form_params).body
        c.payloads = JSON.parse(body.to_s)
      end
    end
  end
end
