require 'spec_helper'

module MessageBusClientWorker
  module Polling
    RSpec.describe GetPayloads do

      context "circuit is open or call failed" do
        it "fails the context" do
          expect(Excon).to receive(:post)
            .and_raise(described_class::EXCEPTIONS.sample)

          result = described_class.execute({
            params: {},
            form_params: {},
            uri: "hi.com",
          })

          expect(result).to be_failure
          expect(result).to be_stop_processing
        end
      end

    end
  end
end
