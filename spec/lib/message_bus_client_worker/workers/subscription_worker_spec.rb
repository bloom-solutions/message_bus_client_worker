require 'spec_helper'

module MessageBusClientWorker
  RSpec.describe SubscriptionWorker do

    it { is_expected.to be_retryable(false) }

    it "delegates work to Poll" do
      expect(Poll).to receive(:call).
        with("https://host.com", "/messages", "Processor", true)

      described_class.new.
        perform("https://host.com", "/messages", "Processor", true)
    end

  end
end
