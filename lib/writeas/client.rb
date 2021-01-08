# lib/client.rb
require 'faraday'
require 'faraday_middleware'
require 'byebug'

module Writeas
  class Client
    def initialize
      @base_url = "https://write.as/"

      @client ||= Faraday.new(@base_url) do |conf|
        conf.response :json
        conf.request :json
        conf.adapter Faraday.default_adapter
      end
    end

    def render_markdown(raw_body)
      body = {
        raw_body: raw_body
      }
      response = @client.post('/api/markdown', body.to_json)
    end
  end
end
