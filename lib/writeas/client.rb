require 'faraday'
require 'faraday_middleware'
require_relative './client_error'
require_relative './markdown_response'
require_relative './post'

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

      if error_response?(response)
        raise ClientError.new(response.reason_phrase, response.status)
      else
        client_response = Writeas::MarkdownResponse.new(response.body)
      end

      return client_response
    end

    def publish_post(body:, title: nil, font: nil, lang: nil, rtl: nil, created: nil, crosspost: nil)
      request_body = {
        body: body,
        title: title,
        font: font,
        lang: lang,
        rtl: rtl,
        created: created,
        crosspost: crosspost
      }

      response = @conn.post('/api/posts', request_body.to_json)

      if error_response?(response)
        raise ClientError.new(response.reason_phrase, response.status)
      else
        post = Writeas::Post.new(response.body)
        return post
      end
    end

    def retrieve_post(post_id:)
      response = @conn.get("/api/posts/#{post_id}")

      if error_response?(response)
        raise ClientError.new(response.reason_phrase, response.status)
      else
        post = Writeas::Post.new(response.body)
        return post
      end
    end

    def update_post(post_id:, body:, token:, title: nil, font: nil, lang: nil, rtl: nil)
      request_body = {
        body: body,
        token: token,
        title: title,
        font: font,
        lang: lang,
        rtl: rtl
      }

      response = @conn.post("/api/posts/#{post_id}", request_body.to_json)

      if error_response?(response)
        raise ClientError.new(response.reason_phrase, response.status)
      else
        post = Writeas::Post.new(response.body)
        return post
      end
    end

    private

    def error_response?(response)
      [400, 401, 403, 404, 405, 410, 429, 500, 502, 503].include? response.status
    end
  end
end
