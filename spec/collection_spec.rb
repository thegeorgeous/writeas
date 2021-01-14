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
end
