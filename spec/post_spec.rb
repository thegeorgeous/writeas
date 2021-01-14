RSpec.describe Writeas::Post do
  let(:stubs)  { Faraday::Adapter::Test::Stubs.new }
  let(:conn)   { Faraday.new { |b| b.adapter(:test, stubs) } }
  let(:client) { Writeas::Client.new }

  describe ".publish" do
    it "publishes a post" do
      body = { body: "This is a post.", title: "My First Post" }

      client.conn = conn
      stubs.post('/api/posts') do |env|
        expect(env.url.path).to eq('/api/posts')
        [
          200,
          { 'Content-Type': 'application/javascript' },
          { "code" => 201,
            "data" => {
                      "id" => "rf3t35fkax0aw",
                      "slug" => nil,
                      "token" => "ozPEuJWYK8L1QsysBUcTUKy9za7yqQ4M",
                      "appearance" => "norm",
                      "language" => "",
                      "rtl" => false,
                      "created" => "2016-07-09T01:43:46Z",
                      "title" =>"My First Post",
                      "body" =>  "This is a post.",
                      "tags" => []
                    }
          }
        ]
      end

      post = described_class.publish(body: "This is a post.", title: "My First Post", client: client)

      expect(post.title).to eq "My First Post"
      expect(post.body).to eq "This is a post."
      expect(post.token).to eq "ozPEuJWYK8L1QsysBUcTUKy9za7yqQ4M"
      expect(post.created).to eq "2016-07-09T01:43:46Z"
      expect(post.appearance).to eq "norm"
    end
  end

  describe ".retrieve" do
    it "retrieves a post" do
      client.conn = conn
      stubs.get('/api/posts/rf3t35fkax0aw') do |env|
        expect(env.url.path).to eq('/api/posts/rf3t35fkax0aw')
        [
          200,
          { 'Content-Type': 'application/javascript' },
          
          { "code" => 200,
            "data" => {
                      "id" => "rf3t35fkax0aw",
                      "slug" => nil,
                      "token" => "ozPEuJWYK8L1QsysBUcTUKy9za7yqQ4M",
                      "appearance" => "norm",
                      "language" => "",
                      "rtl" => false,
                      "created" => "2016-07-09T01:43:46Z",
                      "title" => "My First Post",
                      "body" => "This is a post.",
                      "tags" => [],
                      "views" => 0
                    }
          }
        ]
      end

      post = described_class.retrieve(post_id: 'rf3t35fkax0aw', client: client)

      expect(post.title).to eq "My First Post"
      expect(post.body).to eq "This is a post."
      expect(post.token).to eq "ozPEuJWYK8L1QsysBUcTUKy9za7yqQ4M"
      expect(post.created).to eq "2016-07-09T01:43:46Z"
      expect(post.appearance).to eq "norm"
    end
  end


  describe ".update" do
    it "updates a post" do
      client.conn = conn
      stubs.post('/api/posts/rf3t35fkax0aw') do |env|
        expect(env.url.path).to eq('/api/posts/rf3t35fkax0aw')
        [
          200,
          { 'Content-Type': 'application/javascript' },
          { "code" => 200,
            "data" => {
                      "id" => "rf3t35fkax0aw",
                      "slug" => nil,
                      "token" => "ozPEuJWYK8L1QsysBUcTUKy9za7yqQ4M",
                      "appearance" => "norm",
                      "language" => "",
                      "rtl" => false,
                      "created" => "2016-07-09T01:43:46Z",
                      "title" => "My First Post",
                      "body" => "My post is updated.",
                      "tags" => []
                    }
          }
        ]
      end

      post = described_class.update(
        post_id: 'rf3t35fkax0aw',
        body: "My post is updated.",
        token: "ozPEuJWYK8L1QsysBUcTUKy9za7yqQ4M",
        client: client
      )

      expect(post.title).to eq "My First Post"
      expect(post.body).to eq "My post is updated."
    end
  end

  describe ".delete" do
    it "deletes a post" do
      client.conn = conn
      stubs.delete('/api/posts/rf3t35fkax0aw') do |env|
        expect(env.url.path).to eq('/api/posts/rf3t35fkax0aw')
        [204]
      end

      response = described_class.delete(
        post_id: 'rf3t35fkax0aw',
        token: "ozPEuJWYK8L1QsysBUcTUKy9za7yqQ4M",
        client: client
      )

      expect(response).to be_truthy
    end
  end
end
