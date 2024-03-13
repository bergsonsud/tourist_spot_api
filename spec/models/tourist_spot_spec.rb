# frozen_string_literal: true

require "spec_helper"

RSpec.describe(TouristSpot, type: :model) do
  it { is_expected.to(validate_presence_of(:name)) }
  it { is_expected.to(validate_presence_of(:latitude)) }
  it { is_expected.to(validate_presence_of(:longitude)) }

  describe "#tourist_spot_details_by_language" do
    let(:tourist_spot) { create(:tourist_spot) }
    let(:tourist_spot_detail) { create(:tourist_spot_detail, tourist_spot: tourist_spot) }

    it "returns the tourist spot details by language" do
      expect(tourist_spot.tourist_spot_details_by_language(tourist_spot_detail.language)).to(eq(tourist_spot_detail))
    end
  end

  describe "#find_create_details" do
    let!(:tourist_spot) { create(:tourist_spot) }
    let!(:tourist_spot_detail) { create(:tourist_spot_detail, tourist_spot: tourist_spot) }
    let!(:another_tourist_spot) { create(:tourist_spot) }
    let!(:another_tourist_spot_detail) { create(:tourist_spot_detail, tourist_spot: another_tourist_spot) }

    it "returns the tourist spot details by language" do
      expect(tourist_spot.find_create_details(tourist_spot_detail.language)).to(eq(tourist_spot_detail))
    end

    it "creates the tourist spot details if it does not exist" do
      allow(TranslatorService).to(receive(:new).and_return(double(call: "broken clouds, Brazilian Real, R$, 25.0, Brazil")))
      expect(another_tourist_spot.find_create_details("fr")).to(be_an_instance_of(TouristSpotDetail))
    end
  end

  describe "#translate_fields" do
    let(:tourist_spot) { create(:tourist_spot) }
    let(:tourist_spot_detail) do
      create(
        :tourist_spot_detail,
        tourist_spot: tourist_spot,
        climate: "broken clouds",
        currency: "Brazilian Real",
        currency_symbol: "R$",
        temperature: "25.0",
        country: "Brazil",
      )
    end
    let(:language) { "fr" }

    before do
      allow(TranslatorService).to(receive(:new).and_return(double(call: "nuages fragmentés, Réal brésilien, R$, 25.0, Brésil")))
    end

    it "returns the translated fields" do
      expect(tourist_spot.translate_fields(
        tourist_spot_detail,
        language,
      )).to(eq("{\"climate\":\"nuages fragmentés\",\"currency\":\"Réal brésilien\",\"currency_symbol\":\"R$\",\"temperature\":\"25.0\",\"country\":\"Brésil\"}"))
    end
  end
end
