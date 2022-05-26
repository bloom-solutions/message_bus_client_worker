require 'spec_helper'

module MessageBusClientWorker
  RSpec.describe EnqueuingWorker do

    it { is_expected.to be_retryable(false) }

    it "enqueues a SubscriptionWorker per channel that should be subscribed to" do
      MessageBusClientWorker.configure do |c|
        c.subscriptions = {
          "https://chat.samsaffron.com" => {
            "/message" => "MessageProcessor",
          },
          "https://other.com" => {
            "/fake" => "FakeProcessor",
            "/still_fake" => "StillFakeProcessor",
          },
        }
      end

      described_class.new.perform

      expect(SubscriptionWorker).to have_enqueued_sidekiq_job(
        "https://chat.samsaffron.com",
        {"/message" => "MessageProcessor"}.to_json,
      )
      expect(SubscriptionWorker).to have_enqueued_sidekiq_job(
        "https://other.com",
        {
          "/fake" => "FakeProcessor",
          "/still_fake" => "StillFakeProcessor",
        }.to_json
      )
    end

  end
end
