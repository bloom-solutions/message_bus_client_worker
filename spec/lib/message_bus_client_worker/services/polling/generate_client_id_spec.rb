require 'spec_helper'

module MessageBusClientWorker
  module Polling
    RSpec.describe GenerateClientId do

      context "config .client_id is a proc" do
        it "sets client_id to the value returned by the proc" do
          MessageBusClientWorker.configuration.client_id = -> {"hi"}
          result = described_class.execute
          expect(result.client_id).to eq "hi"
        end
      end

      context "config .client_id is a string" do
        it "sets client_id to the config value" do
          MessageBusClientWorker.configuration.client_id = "there"
          result = described_class.execute
          expect(result.client_id).to eq "there"
        end
      end

    end
  end
end
