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

  describe ".subscribe" do
    context "no subscriptions" do
      it "sets the subscription" do
        described_class.configuration.subscriptions = nil

        described_class.subscribe("site.com", "config" => "hash")

        expect(described_class.configuration.subscriptions["site.com"]).
          to eq({"config" => "hash"})
      end
    end

    context "subscriptions exist" do
      it "adds the subscription" do
        described_class.configuration.subscriptions = {
          "first.com" => { "first" => "hash" }
        }

        described_class.subscribe("site.com", "config" => "hash")

        subscriptions = described_class.configuration.subscriptions

        aggregate_failures do
          expect(subscriptions["first.com"]).to eq({"first" => "hash"})
          expect(subscriptions["site.com"]).to eq({"config" => "hash"})
        end
      end
    end

    context "existing subscription exists" do
      it "warns of the existing subscription and overwrites the subscription" do
        described_class.configuration.subscriptions = {
          "site.com" => { "first" => "hash" }
        }

        expect(described_class).to receive(:warn).
          with(/\[MessageBusClientWorker\] site\.com already/)

        described_class.subscribe("site.com", "config" => "hash")

        subscriptions = described_class.configuration.subscriptions

        aggregate_failures do
          expect(subscriptions["site.com"]).to eq({"config" => "hash"})
        end
      end
    end
  end

end
