module MessageBusClientWorker
  module Polling
    class GetMessages
      extend LightService::Action

      expects :params, :form_params, :uri
      promises :messages

      executed do |c|
        body = HTTP.post(c.uri.to_s, params: c.params, form: c.form_params).body
        c.messages = JSON.parse(body.to_s)
      end
    end
  end
end
