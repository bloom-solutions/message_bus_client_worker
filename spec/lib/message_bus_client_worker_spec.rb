require 'spec_helper'

RSpec.describe MessageBusClientWorker do

  it "is configurable" do
    MessageBusClientWorker.configure do |c|
      c.subscriptions = {
        "https://chat.samsaffron.com" => {
          "/message" => "MessageProcessor",
        }
      }
    end

    message_processor = MessageBusClientWorker.configuration.
      subscriptions["https://chat.samsaffron.com"]["/message"]
    expect(message_processor).to eq "MessageProcessor"
  end

end
