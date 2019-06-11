require 'spec_helper'

module MessageBusClientWorker
  module Polling
    RSpec.describe GenerateParams do

      it([
        "sets form_params with channel indices in priority:",
        "last recorded id, configured custom id, and finally -1",
        "unique to the host, channel, and headers"
      ].join) do
        SetLastId.(
          host: "https://host.com",
          channel: "/points",
          message_id: 30,
          headers: { "Authorization" => "Bearer User1" },
        )

        result1 = described_class.execute(
          host: "https://host.com",
          subscriptions: {
            channels: {
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
          },
          headers: { "Authorization" => "Bearer User1" },
        )

        expect(result1.form_params["/messages"]).to eq "-1"
        expect(result1.form_params["/points"]).to eq "30"
        expect(result1.form_params["/read-before"]).to eq "1"

        result2 = described_class.execute(
          host: "https://host.com",
          subscriptions: {
            channels: {
              "/points" => {
                processor: "DoesNotMatterInThisSpec",
                message_id: 5,
              },
            }
          },
          headers: { "Authorization" => "Bearer User2" },
        )

        expect(result2.form_params["/points"]).to eq "5"
      end

    end
  end
end
