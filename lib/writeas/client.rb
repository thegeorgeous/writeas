require 'faraday'
require 'faraday_middleware'
require_relative './client_error'
require_relative './markdown_response'

module Writeas
  class Client
    attr_accessor :base_url, :conn

    def initialize
      @base_url = "https://write.as/"

      @conn ||= Faraday.new(@base_url) do |conf|
        conf.response :json
        conf.request :json
        conf.adapter Faraday.default_adapter
      end
    end

    def render_markdown(raw_body)
      body = {
        raw_body: raw_body
      }

      response = @conn.post('/api/markdown', body.to_json)

      if [400, 401, 403, 404, 405, 410, 429, 500, 502, 503].include? response.status
        raise ClientError.new(response.reason_phrase, response.status)
      else
        client_response = Writeas::MarkdownResponse.new(response.body)
      end

      return client_response
    end
  end
end
