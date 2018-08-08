require 'spec_helper'

module MessageBusClientWorker
  module Polling
    RSpec.describe GenerateParams do

      it([
        "sets form_params with channel indices in priority:",
        "last recorded id, configured custom id, and finally -1",
      ].join) do
        SetLastId.("https://host.com", "/points", 20)

        resulting_ctx = described_class.execute(
          host: "https://host.com",
          subscriptions: {
            "/messages" => { processor: "DoesNotMatterInThisSpec" },
            "/points" => {
              processor: "DoesNotMatterInThisSpec",
              message_id: 15,
            },
            "/read-before" => {
              processor: "DoesNotMatterInThisSpec",
              message_id: 1,
            },
          }
        )

        expect(resulting_ctx.form_params["/messages"]).to eq "-1"
        expect(resulting_ctx.form_params["/points"]).to eq "20"
        expect(resulting_ctx.form_params["/read-before"]).to eq "1"
      end

    end
  end
end
