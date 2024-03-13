# frozen_string_literal: true

class FaradayRequestService
  attr_accessor :connection

  def initialize(uri)
    raise ArgumentError, "URL cannot be nil or empty" unless uri

    self.connection = Faraday.new(url: uri)
  end

  def call
    response = connection.get
    JSON.parse(response.body)
  end
end
