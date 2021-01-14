module Writeas
  class Collection
    attr_reader :alias, :title, :description, :style_sheet,
                :email, :views, :total_posts, :public

    COLLECTIONS_ENDPOINT = "/api/collections"

    def initialize(data: data)
      @alias = data["alias"]
      @title = data["title"]
      @description = data["description"]
      @style_sheet = data["style_sheet"]
      @email = data["email"]
      @public = data["public"]
      @views = data["views"]
      @total_posts = data["total_posts"]
    end

    class << self
      def create(collection_alias: nil, title: nil, client: nil)
        conn = client || default_client
        body = {
          alias: collection_alias,
          title: title
        }

        response = conn.post(endpoint: "#{COLLECTIONS_ENDPOINT}", body: body)

        return self.new(data: response.data)
      end

      def retrieve(collection_alias:, client: nil)
        conn = client || default_client
        response = conn.get(endpoint: "#{COLLECTIONS_ENDPOINT}/#{collection_alias}")

        return self.new(data: response.data)
      end

      def update(collection_alias:, title: nil, description: nil, stylesheet: nil,
                 script: nil, visibility: nil, pass: nil, mathjax: nil, client: nil)
        conn = client || default_client
        body = {
          title: title,
          description: description,
          stylesheet: stylesheet,
          script: script,
          visibility: visibility,
          pass: pass,
          mathjax: mathjax
        }

        response = conn.post(endpoint: "#{COLLECTIONS_ENDPOINT}/#{collection_alias}", body: body)
        return self.new(data: response.data)
      end

      def delete(collection_alias:, client: nil)
        conn = client || default_client

        conn.delete(endpoint: "#{COLLECTIONS_ENDPOINT}/#{collection_alias}")
        return true
      end

      def publish_post(collection_alias:, body:, title: nil, font: nil,
                       lang: nil, rtl: nil, created: nil, crosspost: nil,
                       client: nil)
        conn = client || default_client
        request_body = {
          body: body,
          title: title,
          font: font,
          lang: lang,
          rtl: rtl,
          created: created,
          crosspost: crosspost
        }

        response = conn.post(endpoint: "#{COLLECTIONS_ENDPOINT}/#{collection_alias}/posts", body: request_body)

        return Post.new(data: response.data)
      end

      private

      def default_client
        Client.new
      end

      def error_response?(response)
        [400, 401, 403, 404, 405, 410, 429, 500, 502, 503].include? response.status
      end
    end
  end
end
