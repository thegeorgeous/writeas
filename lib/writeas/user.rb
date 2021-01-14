module Writeas
  class User
    attr_reader :access_token, :username, :email, :created

    def initialize(data:)
      @access_token = data["access_token"]
      @username = data["user"]["username"]
      @email = data["user"]["email"]
      @created = data["user"]["created"]
    end

    class << self
      def login(username:, pass:, client: nil)
        conn = client || default_client

        body = {
          alias: username,
          pass: pass
        }

        response = conn.post(endpoint: "/api/auth/login", body: body)
        return self.new(data: response.data)
      end

      private

      def default_client
        Client.new
      end
    end
  end
end
