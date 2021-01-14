RSpec.describe Writeas::Collection do
  let(:stubs)  { Faraday::Adapter::Test::Stubs.new }
  let(:conn)   { Faraday.new { |b| b.adapter(:test, stubs) } }
  let(:client) { Writeas::Client.new }

  it "publishes a collection" do
    stubs.post('/api/collections') do |env|
      expect(env.url.path).to eq('/api/collections')
      [
        200,
        { 'Content-Type': 'application/javascript' },
         {
           "code" => 201,
           "data" => {
                     "alias" => "new-blog",
                     "title" => "The Best Blog Ever",
                     "description" => "",
                     "style_sheet" => "",
                     "email" => "new-blog-wjn6epspzjqankz41mlfvz@writeas.com",
                     "views" => 0,
                     "total_posts" => 0
                   }
         }
      ]
    end

    client.conn = conn

    collection = described_class.create(collection_alias: "new-blog", title: "The Best Blog Ever", client: client)

    expect(collection.alias).to eq "new-blog"
    expect(collection.title).to eq "The Best Blog Ever"
  end

  it "retrieves a collection" do
    stubs.get('/api/collections/new-blog') do |env|
      expect(env.url.path).to eq('/api/collections/new-blog')
      [
        200,
        { 'Content-Type': 'application/javascript' },
        {
          "code" => 200,
          "data" => {
                    "alias" => "new-blog",
                    "title" => "The Best Blog Ever",
                    "description" => "",
                    "style_sheet" => "",
                    "public" => true,
                    "views" => 9,
                    "total_posts" => 0
                 }
        }
      ]
    end

    client.conn = conn

    collection = described_class.retrieve(collection_alias: "new-blog", client: client)

    expect(collection.alias).to eq "new-blog"
    expect(collection.title).to eq "The Best Blog Ever"
    expect(collection.public).to eq true
    expect(collection.views).to eq 9
  end

  it "updates a collection" do
    body = {
      description: "A great blog.",
      style_sheet: "body { color: blue; }"
    }

    stubs.post('/api/collections/new-blog') do |env|
      expect(env.url.path).to eq('/api/collections/new-blog')
      [
        200,
        { 'Content-Type': 'application/javascript' },
        {
          "code" => 200,
          "data" => {
                    "alias" => "new-blog",
                    "title" => "The Best Blog Ever",
                    "description" => "A great blog.",
                    "style_sheet" => "body { color: blue; }",
                    "script" => "",
                    "email" => "new-blog-wjn6epspzjqankz41mlfvz@writeas.com",
                    "views" => 0
                 }
        }
      ]
    end

    client.conn = conn

    collection = described_class.update(collection_alias: "new-blog", client: client)

    expect(collection.description).to eq "A great blog."
  end

  it "deletes a collection" do
    stubs.delete('/api/collections/new-blog') do |env|
      expect(env.url.path).to eq('/api/collections/new-blog')
      [204]
    end

    client.conn = conn

    response = described_class.delete(collection_alias: "new-blog", client: client)

    expect(response).to be_truthy
  end

  describe '.publish_post' do
    it "publishes a post" do
      body = { body: "This is a post.", title: "My First Post" }

      stubs.post('/api/collections/new-blog/posts') do |env|
        expect(env.url.path).to eq('/api/collections/new-blog/posts')
        [
          200,
          { 'Content-Type': 'application/json' },
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
              "tags" => [],
              "collection" => {
                "alias" => "new-blog",
                "title" => "The Best Blog Ever",
                "description" => "",
                "style_sheet" => "",
                "public" => true,
                "url" => "https://write.as/new-blog/"
              }
            }
          }
        ]
      end


      client.conn = conn

      post = described_class.publish_post(collection_alias: "new-blog", body: "This is a post.", title: "My First Post", client: client)

      expect(post.title).to eq "My First Post"
      expect(post.body).to eq "This is a post."
      expect(post.token).to eq "ozPEuJWYK8L1QsysBUcTUKy9za7yqQ4M"
      expect(post.created).to eq "2016-07-09T01:43:46Z"
      expect(post.appearance).to eq "norm"
    end
  end

  describe '.retrieve_post' do
    it "retrieves a collection post" do
      stubs.get('/api/collections/new-blog/posts/my-first-post') do |env|
        expect(env.url.path).to eq('/api/collections/new-blog/posts/my-first-post')
        [
          200,
          { 'Content-Type': 'application/json' },
          {
            "code" => 200,
            "data" => {
                      "id" => "hjb7cvwaevy9eayp",
                      "slug" => "my-first-post",
                      "appearance" => "norm",
                      "language" => "",
                      "rtl" => false,
                      "created" => "2016-07-09T14:29:33Z",
                      "title" => "My First Post",
                      "body" => "This is a blog post.",
                      "tags" => [],
                      "views" => 0
                   }
          }

        ]
      end


      client.conn = conn

      post = described_class.retrieve_post(collection_alias: "new-blog", slug: "my-first-post", client: client)

      expect(post.title).to eq "My First Post"
      expect(post.body).to eq "This is a blog post."
      expect(post.created).to eq "2016-07-09T14:29:33Z"
      expect(post.appearance).to eq "norm"
    end
  end

  describe '.retrieve_posts' do
    it "retrieves a list of collection posts" do
      stubs.get('/api/collections/new-blog/posts') do |env|
        expect(env.url.path).to eq('/api/collections/new-blog/posts')
        [
          200,
          { 'Content-Type': 'application/json' },
          {
            "code" => 200,
            "data" => {  
                      "alias" => "new-blog",
                      "title" => "The Best Blog Ever",
                      "description" => "",
                      "style_sheet" => "",
                      "private" => false,
                      "total_posts" => 1,
                      "posts" => [
                                 {
                                    "id" => "hjb7cvwaevy9eayp",
                                    "slug" => "my-first-post",
                                    "appearance" => "norm",
                                    "language" => "",
                                    "rtl" => false,
                                    "created" => "2016-07-09T14:29:33Z",
                                    "title" => "My First Post",
                                    "body" => "This is a blog post.",
                                    "tags" => [],
                                    "views" => 0
                                 }
                               ]
                   }
          }
        ]
      end


      client.conn = conn

      collection = described_class.retrieve_posts(collection_alias: "new-blog", client: client)

      expect(collection.alias).to eq "new-blog"
      expect(collection.title).to eq "The Best Blog Ever"
      expect(collection.posts.count).to eq 1
      expect(collection.posts.first.id).to eq "hjb7cvwaevy9eayp" 
    end
  end
end
