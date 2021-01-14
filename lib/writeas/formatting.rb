module Writeas
  class Formatting
    class << self
      def render_markdown(raw_body:, client: nil)
        conn = client || default_client

        body = {
          raw_body: raw_body
        }

        response = conn.post(endpoint: '/api/markdown', body: body)
        return Markdown.new(response.data["body"])
      end

      private

      def default_client
        Client.new
      end
    end
  end
end
