require 'spec_helper'

module MessageBusClientWorker
  module Polling
    RSpec.describe ProcessMessages do

      let!(:david_processor) do
        DavidProcessor = Class.new do
          def self.call(payload)
            REDIS.set("David", payload["name"])
          end
        end
      end
      let!(:freddie_processor) do
        FreddieProcessor = Class.new do
          def self.call(payload)
            REDIS.set("Freddie", payload["name"])
          end
        end
      end

      it "processes the messages with the correct processor and sets the last id" do
        described_class.execute(
          host: "https://under.pressure",
          subscriptions: {
            "/David" => DavidProcessor.to_s,
            "/Freddie" => FreddieProcessor.to_s,
          },
          messages: [
            {
              "channel" => "/David",
              "message_id" => 3,
              "data" => {"name" => "Bowie"},
            },
            {
              "channel" => "/Freddie",
              "message_id" => 31,
              "data" => {"name" => "Merc"},
            },
            {
              "channel" => "/Freddie",
              "message_id" => 32,
              "data" => {"name" => "Mercury"},
            }
          ]
        )

        expect(REDIS.get("David")).to eq "Bowie"
        expect(REDIS.get("Freddie")).to eq "Mercury"
        david_last_id = GenerateParams.get_last_id_from_redis(
          host: "https://under.pressure",
          channel: "/David",
        )
        expect(david_last_id).to eq "3"
        freddie_last_id = GenerateParams.get_last_id_from_redis(
          host: "https://under.pressure",
          channel: "/Freddie",
        )
        expect(freddie_last_id).to eq "32"
      end

    end
  end
end
