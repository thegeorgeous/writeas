require_relative './client_error'
require 'json'

module Writeas
  class Collection < Response
    attr_reader :alias, :title, :description, :style_sheet,
                :email, :views, :total_posts, :public

    COLLECTIONS_ENDPOINT = "/api/collections"

    def initialize(response_body)
      super(response_body)
      @alias = @data["alias"]
      @title = @data["title"]
      @description = @data["description"]
      @style_sheet = @data["style_sheet"]
      @email = @data["email"]
      @public = @data["public"]
      @views = @data["views"]
      @total_posts = @data["total_posts"]
    end

    class << self
      def create(base_url: nil, collection_alias: nil, title: nil)
        body = {
          alias: collection_alias,
          title: title
        }

        response = client.post("/api/collections", body.to_json)
        if error_response?(response)
          body = JSON.parse(response.body)
          raise Writeas::ClientError.new(body["error_msg"], body["code"])
        else
          collection = self.new(response.body)
          return collection
        end
      end

      def retrieve(collection_alias:, base_url: nil)
        response = client(base_url).get("/api/collections/#{collection_alias}")

        if error_response?(response)
          body = JSON.parse(response.body)
          raise Writeas::ClientError.new(body["error_msg"], body["code"])
        else
          collection = self.new(response.body)
          return collection
        end
      end

      private
     
      def client(base_url: nil)
        Writeas::Client.new(base_url).conn
      end

      def error_response?(response)
        [400, 401, 403, 404, 405, 410, 429, 500, 502, 503].include? response.status
      end
    end
  end
end
