require 'spec_helper'

module MessageBusClientWorker
  module Polling
    RSpec.describe GenerateParams do

      it "generates the channel indices with from the last message that was processed, if any" do
        SetLastId.("https://host.com", "/points", 20)

        resulting_ctx = described_class.execute(
          host: "https://host.com",
          subscriptions: {
            "/messages" => { processor: "DoesNotMatterInThisSpec" },
            "/points" => { processor: "DoesNotMatterInThisSpec" },
          }
        )

        expect(resulting_ctx.form_params["/messages"]).to eq "0"
        expect(resulting_ctx.form_params["/points"]).to eq "20"
      end

    end
  end
end
