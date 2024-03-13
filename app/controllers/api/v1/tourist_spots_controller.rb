# frozen_string_literal: true

module Api
  module V1
    class TouristSpotsController < ApplicationController
      def search
        if params[:query].blank?
          render(json: { error: "query parameter is required" }, status: :bad_request)
          return
        end
        @tourist_spot, @tourist_spot_details = TouristSpotSearchService.new(
          params[:query],
          params[:units],
          params[:language] || "en",
        ).call

        if @tourist_spot.nil?
          render(json: @tourist_spot_details, status: :bad_request)
          return
        end
      end
    end
  end
end
