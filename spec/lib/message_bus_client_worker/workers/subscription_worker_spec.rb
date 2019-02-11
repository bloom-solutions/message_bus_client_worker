require 'spec_helper'

module MessageBusClientWorker
  RSpec.describe SubscriptionWorker do

    it { is_expected.to be_retryable(0) }

    it "delegates work to Poll" do
      params = { processor: "Processor" }
      subscriptions = {
        headers: { "Authorization" => "Bearer me" },
        channels: { "/messages" => params }
      }

      expect(Poll).to receive(:call).
        with("https://host.com", subscriptions, true)

      described_class.new.
        perform("https://host.com", subscriptions, true)
    end

  end
end
