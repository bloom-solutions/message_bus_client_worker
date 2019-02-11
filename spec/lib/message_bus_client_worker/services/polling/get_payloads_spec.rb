require 'spec_helper'

module MessageBusClientWorker
  module Polling
    RSpec.describe GetPayloads do

      let(:form_params) { { "/channel" => 0 } }
      let(:params) { { dlp: 't' } }
      let(:response) do
        instance_double(Excon::Response, {
          body: {response: 1}.to_json,
        })
      end

      context "With headers" do
        let(:headers) do
          { "Authorization" => "Bearer my-token" }
        end

        it "fetches the payloads for the uri along with the headers" do
          expect(Excon).to receive(:post).with("uri.com", {
            headers: headers,
            query: params,
            body: URI.encode_www_form(form_params),
          }).and_return(response)

          result = described_class.execute(
            params: params,
            form_params: form_params,
            headers: headers,
            uri: "uri.com",
          )

          expect(result.payloads["response"]).to eq 1
        end
      end

      context "With no headers set" do
        it "fetches the payloads for the uri without the headers" do
          expect(Excon).to receive(:post).with("uri.com", {
            query: params,
            body: URI.encode_www_form(form_params),
          }).and_return(response)

          result = described_class.execute(
            params: params,
            form_params: form_params,
            headers: nil,
            uri: "uri.com",
          )

          expect(result.payloads["response"]).to eq 1
        end
      end

    end
  end
end
