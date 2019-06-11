require 'spec_helper'

module MessageBusClientWorker
  module Polling
    RSpec.describe GenLastIdKey do

      context "host, channel, headers are the same" do
        it "generates the same hash" do
          expect(described_class.(host: "a", channel: "/c", headers: {A: "1"})).
            to eq described_class.(host: "a", channel: "/c", headers: {A: "1"})
        end
      end

      context "host is different" do
        it "generates a different hash" do
          expect(described_class.(host: "a", channel: "/c", headers: {A: "1"})).
            to_not eq described_class.(host: "b", channel: "/c", headers: {A: "1"})
        end
      end

      context "headers are different" do
        it "generates a different hash" do
          expect(described_class.(host: "a", channel: "/c", headers: {A: "1"})).
            to_not eq described_class.(host: "a", channel: "/c", headers: {})
        end
      end

      context "no headers are passed in" do
        it "treats headers `nil` or no headers passed in the same way" do
          expect(described_class.(host: "a", channel: "/c", headers: {})).
            to eq described_class.(host: "a", channel: "/c")
        end
      end

    end
  end
end
