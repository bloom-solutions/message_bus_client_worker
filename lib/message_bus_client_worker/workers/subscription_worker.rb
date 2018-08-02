module MessageBusClientWorker
  class SubscriptionWorker

    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(host, channel, processor_class_name, long=true)
      client_id = SecureRandom.uuid
      uri = Addressable::URI.parse(host)
      uri.path = "/message-bus/#{client_id}/poll"

      params = {dlp: "t"}
      form_params = {channel => 0}
      body = HTTP.post(uri.to_s, params: params, form: form_params).body

      messages = JSON.parse(body.to_s)
      processor_class = Kernel.const_get(processor_class_name)

      messages.each do |message|
        processor_class.(message["data"])
      end
    end

  end
end
