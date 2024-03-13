# frozen_string_literal: true

require "rails_helper"

RSpec.describe(TouristSpotDetail, type: :model) do
  describe "#get_updated_values" do
    let(:tourist_spot) { create(:tourist_spot) }
    let(:detail) { create(:tourist_spot_detail, tourist_spot: tourist_spot) }

    context "when the record is new" do
      it "does not call update_values" do
        expect(detail).not_to(receive(:update_values))
        detail
      end
    end

    context "when the record is not new" do
      it "calls update_values if updated more than 10 minutes ago" do
        detail.update(updated_at: 20.minutes.ago)
        expect(detail).to(receive(:update_values))
        detail.updated_values?
      end

      it "does not call update_values if updated less than 10 minutes ago" do
        detail.update(updated_at: Time.current)
        expect(detail).not_to(receive(:update_values))
        detail.updated_values?
      end
    end
  end

  describe "#update_values" do
    let(:tourist_spot) { create(:tourist_spot) }
    let(:detail) { create(:tourist_spot_detail, tourist_spot: tourist_spot) }

    before do
      allow(detail).to(receive(:get_new_data).and_return({
        "cod" => 200,
        "weather" => [{ "description" => "Sunny" }],
        "main" => { "temp" => 26.7 },
      }))
    end

    it "updates climate and temperature if data is present" do
      detail.update_values
      detail.reload
      expect(detail.climate).to(eq("Sunny"))
      expect(detail.temperature).to(eq("26.7"))
    end
  end
end
