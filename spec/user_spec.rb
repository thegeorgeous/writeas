RSpec.describe Writeas::User do
  let(:stubs)  { Faraday::Adapter::Test::Stubs.new }
  let(:conn)   { Faraday.new { |b| b.adapter(:test, stubs) } }
  let(:client) { Writeas::Client.new }

  describe '.login' do
    it "logs a user" do
      client.conn = conn

      stubs.post('/api/auth/login') do |env|
        expect(env.url.path).to eq('/api/auth/login')
        [
          200,
          { 'Content-Type': 'application/javascript' },
          { "code" => 201,
            "data" => {
              "access-token" => "7eb37433-621e-447f-54ce-1a0a77de53a4",
              "user" => {
                "username" => "matt",
                "email" => "matt@example.com",
                "created" => "2015-02-03T02:41:19Z"
              }
            }
          }
        ]
      end

      user = described_class.login(username: "matt" , pass: "matt1234", client: client)
      expect(user.username).to eq "matt"
      expect(user.email).to eq "matt@example.com"
      expect(user.created).to eq "2015-02-03T02:41:19Z"
    end
  end
end
