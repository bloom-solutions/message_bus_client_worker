require 'spec_helper'

module MessageBusClientWorker
  module Polling
    RSpec.describe ProcessMessages do

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

      it "processes the messages with the correct processor and sets the last id" do
        described_class.execute(
          host: "https://under.pressure",
          subscriptions: {
            "/David" => { processor: DavidProcessor.to_s },
            "/Freddie" => { processor: FreddieProcessor.to_s },
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
        expect(GetLastId.("https://under.pressure", "/David")).to eq "3"
        expect(GetLastId.("https://under.pressure","/Freddie")).to eq "32"
      end

    end
  end
end
