require 'spec_helper'

module MessageBusClientWorker
  RSpec.describe SubscriptionWorker do

    it { is_expected.to be_retryable(false) }

    context "polling" do
      it "makes a plain http call" do
        unique_message = SecureRandom.uuid
        Publish.("The Shins", "Port of Morrow - #{unique_message}")

        described_class.new.perform(
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

    it "continues where it left off"

  end
end
