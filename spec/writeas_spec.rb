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
end
