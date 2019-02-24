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

  it "allows customization for client_id" do
    MessageBusClientWorker.configuration.client_id = -> {"client-id"}
    expect(MessageBusClientWorker.configuration.client_id.()).to eq "client-id"

    MessageBusClientWorker.configuration.client_id = "hi"
    expect(MessageBusClientWorker.configuration.client_id).to eq "hi"
  end

end
