require 'spec_helper'

module MessageBusClientWorker
  RSpec.describe Poll do

    context "polling" do
      it "makes a plain http call" do
        unique_message = SecureRandom.uuid
        Publish.("The Shins", "Port of Morrow - #{unique_message}")

        described_class.(
          CONFIG[:chat_server_url],
          "/message",
          TestProc.to_s,
          false,
        )

        payload = REDIS.get(TestProc::RANDOM)
        parsed_payload = JSON.parse(payload)

        expect(parsed_payload["name"]).to eq "The Shins"
        expect(parsed_payload["data"]).to eq "Port of Morrow - #{unique_message}"
      end
    end

    context "long polling" do
      it "makes a call with polling set to true, attempting to stream"
    end

    context "recovery" do
      let!(:second_processor) do
        SaverProcessor = Class.new do
          def self.call(payload)
            REDIS.set(payload["name"], payload["data"])
          end
        end
      end

      it "continues where it left off" do
        name_randomness = SecureRandom.uuid
        message_1 = SecureRandom.uuid
        Publish.("First #{name_randomness}", message_1)

        described_class.(
          CONFIG[:chat_server_url],
          "/message",
          TestProc.to_s,
          false,
        )

        message_2 = SecureRandom.uuid
        Publish.("Second #{name_randomness}", message_2)

        described_class.(
          CONFIG[:chat_server_url],
          "/message",
          SaverProcessor.to_s,
          false,
        )

        expect(REDIS.get("First #{name_randomness}")).to be_nil
        expect(REDIS.get("Second #{name_randomness}")).to eq message_2
      end
    end

  end
end
