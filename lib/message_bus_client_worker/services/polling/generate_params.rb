module MessageBusClientWorker
  module Polling
    class GenerateParams
      extend LightService::Action

      expects :host, :subscriptions, :headers
      promises :params, :form_params

      DEFAULT_MESSAGE_ID = "-1".freeze

      executed do |c|
        channels = c.subscriptions[:channels]

        c.params = { dlp: 't' }
        c.form_params = channels.each_with_object({}) do |sub, hash|
          channel = sub[0]
          custom_message_id = sub[1][:message_id] ? sub[1][:message_id].to_s : nil

          last_id_in_memory = GetLastId.(
            host: c.host,
            channel: channel,
            headers: c.headers,
          )

          hash[channel] = last_id_in_memory ||
            custom_message_id ||
            DEFAULT_MESSAGE_ID
        end
      end

    end
  end
end
