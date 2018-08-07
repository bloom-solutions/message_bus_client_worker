module MessageBusClientWorker
  module Polling
    class GenerateParams
      extend LightService::Action

      CHANNEL_INDICES_NAME = "message_bus_client_worker_channel_indices".freeze
      expects :host, :subscriptions
      promises :params, :form_params

      executed do |c|
        c.params = { dlp: 't' }
        c.form_params = c.subscriptions.each_with_object({}) do |sub, hash|
          hash[sub[0]] = GetLastId.(c.host, sub[0])
        end
      end

    end
  end
end
