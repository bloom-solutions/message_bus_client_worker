require 'spec_helper'

module MessageBusClientWorker
  RSpec.describe SubscriptionWorker do

    it { is_expected.to be_retryable(false) }

    it "is supposed to not allow enqueuing of the same job until the job is done" do
      expect(described_class.sidekiq_options["lock"]).to eq :until_executed
    end

    it "considers the host the unique arg" do
      expect(described_class.sidekiq_options["unique_args"]).to eq :unique_args

      unique_args = described_class.unique_args("host", {"channel" => {}})
      expect(unique_args).to match_array(["host"])
    end

    it "delegates work to Poll" do
      params = { processor: "Processor" }

      expect(Poll).to receive(:call).
        with("https://host.com", {"/messages" => params }, true)

      described_class.new.
        perform("https://host.com", {"/messages" => params }, true)
    end

  end
end
