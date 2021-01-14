RSpec.describe Writeas::Formatting do
  let(:stubs)  { Faraday::Adapter::Test::Stubs.new }
  let(:conn)   { Faraday.new { |b| b.adapter(:test, stubs) } }
  let(:client) { Writeas::Client.new }

  describe ".render_markdown" do
    it "renders markdown" do
      client.conn = conn

      stubs.post('/api/markdown') do |env|
        expect(env.url.path).to eq('/api/markdown')
        [
          200,
          { 'Content-Type': 'application/json' },
          {"code" => 200, "data" => { "body" => "<p>This is <em>formatted</em> in <strong>Markdown</strong>.</p>"} }
        ]
      end

      markdown = described_class.render_markdown(raw_body: "This is *formatted* in __Markdown__.", client: client)

      expect(markdown.class).to be Writeas::Markdown
      expect(markdown.body).to eq "<p>This is <em>formatted</em> in <strong>Markdown</strong>.</p>"
    end
  end
end
