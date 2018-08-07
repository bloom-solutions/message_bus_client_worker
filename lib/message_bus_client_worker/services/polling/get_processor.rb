module MessageBusClientWorker
  module Polling
    class GetProcessor
      extend LightService::Action

      expects :processor_class_name
      promises :processor_class

      executed do |c|
        c.processor_class = Kernel.const_get(c.processor_class_name)
      end
    end
  end
end

