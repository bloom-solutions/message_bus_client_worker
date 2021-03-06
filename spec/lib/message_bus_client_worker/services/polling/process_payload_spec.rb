require 'spec_helper'

module MessageBusClientWorker
  module Polling
    RSpec.describe ProcessPayload do

      before do
        DavidProcessor ||= Class.new do
          def self.call(data, _)
            REDIS.set("David", data["name"])
          end
        end

        FreddieProcessor ||= Class.new do
          def self.call(data, _, _)
            REDIS.set("Freddie", data["name"])
          end
        end
      end

      it "processes the payloads with the correct processor and sets the last id" do
        described_class.execute(
          host: "https://under.pressure",
          subscriptions: {
            channels: {
              "/David" => { processor: DavidProcessor.to_s },
              "/Freddie" => { processor: FreddieProcessor.to_s },
            }
          },
          payload: {
            "channel" => "/David",
            "message_id" => 3,
            "data" => {"name" => "Bowie"},
          },
          headers: nil,
        )

        expect(REDIS.get("David")).to eq "Bowie"
        last_id = GetLastId.(host: "https://under.pressure", channel: "/David")
        expect(last_id).to eq "3"

        described_class.execute(
          host: "https://under.pressure",
          subscriptions: {
            channels: {
              "/David" => { processor: DavidProcessor.to_s },
              "/Freddie" => { processor: FreddieProcessor.to_s },
            }
          },
          payload: {
            "channel" => "/Freddie",
            "message_id" => 31,
            "data" => {"name" => "Merc"},
          },
          headers: { "Accept" => "application/json" },
        )

        expect(REDIS.get("Freddie")).to eq "Merc"
        last_id = GetLastId.(
          host: "https://under.pressure",
          channel: "/Freddie",
          headers: {"Accept" => "application/json"},
        )
        expect(last_id).to eq "31"

        described_class.execute(
          host: "https://under.pressure",
          subscriptions: {
            channels: {
              "/David" => { processor: DavidProcessor.to_s },
              "/Freddie" => { processor: FreddieProcessor.to_s },
            }
          },
          payload: {
            "channel" => "/Freddie",
            "message_id" => 32,
            "data" => {"name" => "Mercury"},
          },
          headers: { "Authorization" => "Bearer myself" },
        )

        expect(REDIS.get("Freddie")).to eq "Mercury"
        last_id = GetLastId.(
          host: "https://under.pressure",
          channel: "/Freddie",
          headers: { "Authorization" => "Bearer myself" },
        )
        expect(last_id).to eq "32"
      end

      context "given a payload with a channel not being watched" do
        it "does nothing, including not blow up" do
          expect do
            described_class.execute(
              host: "https://under.pressure",
              subscriptions: {
                channels: {
                  "/David" => { processor: DavidProcessor.to_s },
                },
              },
              payload: {
                "channel" => "/__status",
                "message_id" => "-1",
              },
              headers: nil,
            )
          end.to_not raise_error
        end
      end

    end
  end
end
