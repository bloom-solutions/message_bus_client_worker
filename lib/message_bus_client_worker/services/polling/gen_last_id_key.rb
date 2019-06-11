module MessageBusClientWorker
  module Polling
    class GenLastIdKey

      def self.call(host:, channel:, headers: {})
        key_parts = [host, channel]
        (headers || {}).each do |key, value|
          key_parts << [key, value].join("_")
        end

        Digest::SHA256.hexdigest(key_parts.join("-"))
      end

    end
  end
end
