# frozen_string_literal: true

RSpec.describe(TranslatorService) do
  describe "#call" do
    let(:text) { "Hello" }
    let(:to_language) { "es" }
    let(:subscription_key) { "your_subscription_key" }
    let(:location) { "eastus" }
    let(:endpoint) { "https://api.cognitive.microsofttranslator.com" }

    before do
      allow(ENV).to(receive(:[]).with("AZURE_TRANSLATOR_TEXT_API_KEY").and_return(subscription_key))
    end

    context "when API call is successful" do
      it "returns translated text" do
        stub_request(:post, "#{endpoint}/translate?api-version=3.0&to=#{to_language}")
          .with(
            headers: {
              "Content-type" => "application/json",
              "Ocp-Apim-Subscription-Key" => subscription_key,
              "Ocp-Apim-Subscription-Region" => location,
            },
            body: JSON.generate([{ text: text }]),
          )
          .to_return(status: 200, body: '[{ "translations": [{ "text": "Hola" }] }]', headers: {})

        service = described_class.new(text, to_language)
        result = service.call

        expect(result).to(eq("Hola"))
      end
    end
  end
end
