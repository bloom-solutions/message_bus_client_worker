require 'spec_helper'

module MessageBusClientWorker
  RSpec.describe SubscriptionWorker do

    it { is_expected.to be_retryable(0) }

    describe "#perform" do
      let(:params) { { processor: "Processor" } }
      let(:subscriptions_hash) do
        {
          headers: { "Authorization" => "Bearer me" },
          channels: { "/messages" => params }
        }
      end

      it "delegates work to Poll" do
        expect(Poll).to receive(:call).
          with("https://host.com", subscriptions_hash, true)

        described_class.new.
          perform("https://host.com", subscriptions_hash.to_json, true)
      end
    end

  end
end
