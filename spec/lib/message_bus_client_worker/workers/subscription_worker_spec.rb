require 'spec_helper'

module MessageBusClientWorker
  RSpec.describe SubscriptionWorker do

    it { is_expected.to be_retryable(false) }

    it "is supposed to not allow enqueuing of the same job until the job is done" do
      expect(described_class.sidekiq_options["lock"]).to eq :until_executed
    end

    it "delegates work to Poll" do
      expect(Poll).to receive(:call).
        with("https://host.com", {"/messages" => "Processor"}, true)

      described_class.new.
        perform("https://host.com", {"/messages" => "Processor"}, true)
    end

  end
end
