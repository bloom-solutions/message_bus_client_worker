module MessageBusClientWorker
  module Polling
    class GetPayloads
      extend LightService::Action

      EXCEPTIONS = [
        HTTP::ConnectionError,
      ]
      expects :params, :form_params, :uri
      promises :payloads

      executed do |c|
        response = excon_circuit.run do
          Excon.post(c.uri, {
            query: c.params,
            body: URI.encode_www_form(c.form_params)
          })
        end

        if response.nil?
          c.fail_and_return!("Unable to connect to #{c.uri}")
        end

        c.payloads = JSON.parse(response.body.to_s)
      end

      def self.excon_circuit
        Circuitbox.circuit(:message_bus_client_worker_excon, {
          exceptions: EXCEPTIONS,
        })
      end
    end
  end
end
