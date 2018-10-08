require 'spec_helper'

module MessageBusClientWorker
  RSpec.describe SubscriptionWorker do

    # NOTE: death handlers are not executed with retry false until
    # https://github.com/mperham/sidekiq/pull/3980
    it { is_expected.to be_retryable(0) }

    it "is supposed to not allow enqueuing of the same job until the job is done" do
      expect(described_class.sidekiq_options["lock"]).to eq :until_executed
    end

    it "logs on unique conflict" do
      expect(described_class.sidekiq_options["on_conflict"]).to eq :log
    end

    it "considers the host the unique arg" do
      expect(described_class.sidekiq_options["unique_args"]).to eq :unique_args

      unique_args = described_class.unique_args(["host", {"channel" => {}}])
      expect(unique_args).to match_array(["host", {"channel" => {}}])
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
