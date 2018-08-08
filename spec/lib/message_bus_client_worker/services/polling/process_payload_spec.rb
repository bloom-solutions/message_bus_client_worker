require 'spec_helper'

module MessageBusClientWorker
  module Polling
    RSpec.describe ProcessPayload do

      let!(:david_processor) do
        DavidProcessor = Class.new do
          def self.call(data, _)
            REDIS.set("David", data["name"])
          end
        end
      end
      let!(:freddie_processor) do
        FreddieProcessor = Class.new do
          def self.call(data, _)
            REDIS.set("Freddie", data["name"])
          end
        end
      end

      it "processes the payloads with the correct processor and sets the last id" do
        described_class.execute(
          host: "https://under.pressure",
          subscriptions: {
            "/David" => { processor: DavidProcessor.to_s },
            "/Freddie" => { processor: FreddieProcessor.to_s },
          },
          payload: {
            "channel" => "/David",
            "message_id" => 3,
            "data" => {"name" => "Bowie"},
          },
        )

        expect(REDIS.get("David")).to eq "Bowie"
        expect(GetLastId.("https://under.pressure", "/David")).to eq "3"

        described_class.execute(
          host: "https://under.pressure",
          subscriptions: {
            "/David" => { processor: DavidProcessor.to_s },
            "/Freddie" => { processor: FreddieProcessor.to_s },
          },
          payload: {
            "channel" => "/Freddie",
            "message_id" => 31,
            "data" => {"name" => "Merc"},
          },
        )

        expect(REDIS.get("Freddie")).to eq "Merc"
        expect(GetLastId.("https://under.pressure", "/Freddie")).to eq "31"

        described_class.execute(
          host: "https://under.pressure",
          subscriptions: {
            "/David" => { processor: DavidProcessor.to_s },
            "/Freddie" => { processor: FreddieProcessor.to_s },
          },
          payload: {
            "channel" => "/Freddie",
            "message_id" => 32,
            "data" => {"name" => "Mercury"},
          }
        )

        expect(REDIS.get("Freddie")).to eq "Mercury"
        expect(GetLastId.("https://under.pressure","/Freddie")).to eq "32"
      end

      context "given a payload with a channel not being watched" do
        it "does nothing, including not blow up" do
          expect do
            described_class.execute(
              host: "https://under.pressure",
              subscriptions: {
                "/David" => { processor: DavidProcessor.to_s },
              },
              payload: {
                "channel" => "/__status",
                "message_id" => "-1",
              }
            )
          end.to_not raise_error
        end
      end

    end
  end
end
