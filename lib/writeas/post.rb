module Writeas
  class Post
    POST_ENDPOINT = "/api/posts"

    attr_reader :id, :slug, :token, :appearance, :language, :rtl, :created, 
                :title, :body, :tags

    def initialize(data:)
      @id = data["id"]
      @slug = data["slug"]
      @token = data["token"]
      @appearance = data["appearance"]
      @language = data["language"]
      @rtl = data["rtl"]
      @created = data["created"]
      @title = data["title"]
      @body = data["body"]
      @tags = data["tags"]
    end

    class << self
      def publish(body:, client: nil, title: nil, font: nil, lang: nil, rtl: nil, created: nil, crosspost: nil)
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

        response = conn.post(endpoint: POST_ENDPOINT, body: request_body)

        return self.new(data: response.data)
      end

      def retrieve(post_id:, client: nil)
        conn = client || default_client 
        response = conn.get(endpoint: "#{POST_ENDPOINT}/#{post_id}")

        return self.new(data: response.data)
      end

      def update(post_id:, body:, token:, title: nil, font: nil, lang: nil, rtl: nil, client: nil)
        conn = client || default_client 

        request_body = {
          body: body,
          token: token,
          title: title,
          font: font,
          lang: lang,
          rtl: rtl
        }

        response = conn.post(endpoint: "#{POST_ENDPOINT}/#{post_id}", body: request_body)

        return self.new(data: response.data)
      end

      def delete(post_id:, token:, client: nil)
        conn = client || default_client
        conn.delete(endpoint: "#{POST_ENDPOINT}/#{post_id}", body: {token: token})
      end

      private

      def default_client
        Client.new
      end
    end
  end
end
