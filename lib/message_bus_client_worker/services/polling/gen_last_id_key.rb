module MessageBusClientWorker
  module Polling
    class GenLastIdKey

      def self.call(host, channel)
        [host, channel].join("-")
      end

    end
  end
end
