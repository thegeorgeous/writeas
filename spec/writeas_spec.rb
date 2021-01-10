RSpec.describe Writeas do
  let(:stubs)  { Faraday::Adapter::Test::Stubs.new }
  let(:conn)   { Faraday.new { |b| b.adapter(:test, stubs) } }
  let(:client) { Writeas::Client.new }

  it "has a version number" do
    expect(Writeas::VERSION).not_to be nil
  end


  it "renders markdown" do
    raw_body = "This is *formatted* in __Markdown__."
    body = {
      raw_body: raw_body
    }

    client.conn = conn
    stubs.post('/api/markdown') do |env|
      expect(env.url.path).to eq('/api/markdown')
      [
        200,
        { 'Content-Type': 'application/javascript' },
        '{"code": 200, "data": { "body": "<p>This is <em>formatted</em> in <strong>Markdown</strong>.</p>"} }'
      ]
    end

    response = client.render_markdown(raw_body)

    expect(response.code).to eq 200
    expect(response.body).to eq "<p>This is <em>formatted</em> in <strong>Markdown</strong>.</p>"
  end

  it "publishes a post" do
    body = { body: "This is a post.", title: "My First Post" }

    client.conn = conn
    stubs.post('/api/posts') do |env|
      expect(env.url.path).to eq('/api/posts')
      [
        200,
        { 'Content-Type': 'application/javascript' },
        '
          { "code": 201, 
            "data": {
                      "id": "rf3t35fkax0aw", 
                      "slug": null,
                      "token": "ozPEuJWYK8L1QsysBUcTUKy9za7yqQ4M",
                      "appearance": "norm",
                      "language": "",
                      "rtl": false,
                      "created": "2016-07-09T01:43:46Z",
                      "title": "My First Post",
                      "body": "This is a post.",
                      "tags": []
                    }
          }
       '
      ]
    end

    response = client.publish_post(body: "This is a post.", title: "My First Post")

    expect(response.code).to eq 201
    expect(response.title).to eq "My First Post"
    expect(response.body).to eq "This is a post."
    expect(response.token).to eq "ozPEuJWYK8L1QsysBUcTUKy9za7yqQ4M"
    expect(response.created).to eq "2016-07-09T01:43:46Z"
    expect(response.appearance).to eq "norm"
  end

  it "retrieves a post" do
    client.conn = conn
    stubs.get('/api/posts/rf3t35fkax0aw') do |env|
      expect(env.url.path).to eq('/api/posts/rf3t35fkax0aw')
      [
        200,
        { 'Content-Type': 'application/javascript' },
        '
          { "code": 200, 
            "data": {
                      "id": "rf3t35fkax0aw", 
                      "slug": null,
                      "token": "ozPEuJWYK8L1QsysBUcTUKy9za7yqQ4M",
                      "appearance": "norm",
                      "language": "",
                      "rtl": false,
                      "created": "2016-07-09T01:43:46Z",
                      "title": "My First Post",
                      "body": "This is a post.",
                      "tags": [],
                      "views": 0
                    }
          }
       '
      ]
    end

    response = client.retrieve_post(post_id: 'rf3t35fkax0aw')

    expect(response.code).to eq 200
    expect(response.title).to eq "My First Post"
    expect(response.body).to eq "This is a post."
    expect(response.token).to eq "ozPEuJWYK8L1QsysBUcTUKy9za7yqQ4M"
    expect(response.created).to eq "2016-07-09T01:43:46Z"
    expect(response.appearance).to eq "norm"
  end

 it "updates a post" do
    client.conn = conn
    stubs.post('/api/posts/rf3t35fkax0aw') do |env|
      expect(env.url.path).to eq('/api/posts/rf3t35fkax0aw')
      [
        200,
        { 'Content-Type': 'application/javascript' },
        '
          { "code": 200, 
            "data": {
                      "id": "rf3t35fkax0aw", 
                      "slug": null,
                      "token": "ozPEuJWYK8L1QsysBUcTUKy9za7yqQ4M",
                      "appearance": "norm",
                      "language": "",
                      "rtl": false,
                      "created": "2016-07-09T01:43:46Z",
                      "title": "My First Post",
                      "body": "My post is updated.",
                      "tags": []
                    }
          }
       '
      ]
    end

    response = client.update_post(
      post_id: 'rf3t35fkax0aw', 
      body: "My post is updated.", 
      token: "ozPEuJWYK8L1QsysBUcTUKy9za7yqQ4M"
    )

    expect(response.code).to eq 200
    expect(response.title).to eq "My First Post"
    expect(response.body).to eq "My post is updated."
  end
end
