# frozen_string_literal: true

class TranslatorService
  attr_accessor :subscription_key, :location, :endpoint, :text, :to_language

  def initialize(text, to_language)
    self.subscription_key = ENV["AZURE_TRANSLATOR_TEXT_API_KEY"]
    self.location = "eastus"
    self.endpoint = "https://api.cognitive.microsofttranslator.com"
    self.text = text
    self.to_language = to_language
  end

  def call
    path = "/translate?api-version=3.0"
    params = "&to=#{to_language}"
    uri = URI(endpoint + path + params)
    content = JSON.generate([{ text: text }])

    request = Net::HTTP::Post.new(uri)
    request["Content-type"] = "application/json"
    request["Content-length"] = content.length
    request["Ocp-Apim-Subscription-Key"] = subscription_key
    request["Ocp-Apim-Subscription-Region"] = location
    request["X-ClientTraceId"] = SecureRandom.uuid
    request.body = content

    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
      http.request(request)
    end

    if response
      result = JSON.parse(response.body)
      result.map { |item| item["translations"] }.flatten.map { |translation| translation["text"] }.join("\n")
    end
  end
end
