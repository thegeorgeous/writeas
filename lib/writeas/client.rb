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

    def get(endpoint:, body: nil)
      response = @conn.get(endpoint, body)

      if error_response?(response)
        response_body = JSON.parse(response.body)
        raise ClientError.new(response_body["error_msg"], response_body["code"])
      else
        return Response.new(response.body)
      end
    end

    def delete(endpoint:, body: nil)
      response = @conn.delete(endpoint, body)

      if error_response?(response)
        response_body = JSON.parse(response.body)
        raise ClientError.new(response_body["error_msg"], response_body["code"])
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
