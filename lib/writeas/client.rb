require_relative './client_error'
require_relative './post'

module Writeas
  class Client
    attr_accessor :base_url, :conn

    def initialize(base_url=nil)
      @base_url = base_url || "https://write.as/"

      @conn ||= Faraday.new(@base_url) do |conf|
        conf.response :json
        conf.request :json
        conf.adapter Faraday.default_adapter
      end
    end


    def post(endpoint:, body: nil)
      response = @conn.post(endpoint, body.to_json)

      if error_response?(response)
        response_body = JSON.parse(response.body)
        raise ClientError.new(response_body["error_msg"], response_body["code"])
      else
        return Response.new(response.body)
      end
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

    def delete_post(post_id:, token:)
      response = @conn.delete("/api/posts/#{post_id}", {token: token})

      if error_response?(response)
        raise ClientError.new(response.reason_phrase, response.status)
      else
        return true
      end
    end

    private

    def error_response?(response)
      [400, 401, 403, 404, 405, 410, 429, 500, 502, 503].include? response.status
    end
  end
end
