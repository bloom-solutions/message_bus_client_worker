require 'spec_helper'

module MessageBusClientWorker
  RSpec.describe SubscriptionWorker do

    it { is_expected.to be_retryable(0) }

    it "delegates work to Poll" do
      params = { processor: "Processor" }

      expect(Poll).to receive(:call).
        with("https://host.com", {"/messages" => params }, true)

      described_class.new.
        perform("https://host.com", {"/messages" => params }, true)
    end

  end
end
