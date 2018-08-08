module MessageBusClientWorker
  module Polling
    class GenerateParams
      extend LightService::Action

      expects :host, :subscriptions
      promises :params, :form_params

      DEFAULT_MESSAGE_ID = "-1".freeze

      executed do |c|
        c.params = { dlp: 't' }
        c.form_params = c.subscriptions.each_with_object({}) do |sub, hash|
          custom_message_id = sub[1][:message_id] ? sub[1][:message_id].to_s : nil
          hash[sub[0]] = GetLastId.(c.host, sub[0]) ||
            custom_message_id ||
            DEFAULT_MESSAGE_ID
        end
      end

    end
  end
end
