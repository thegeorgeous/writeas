RSpec.describe Writeas do
  let(:client) { Writeas::Client.new }

  it "has a version number" do
    expect(Writeas::VERSION).not_to be nil
  end


  it "renders markdown" do
    raw_body = "This is *formatted* in __Markdown__."
    body = {
      raw_body: raw_body
    }

    response = client.render_markdown(raw_body)

    code = response.body["code"]
    data = response.body["data"]

    expect(response.status).to eq 200
    expect(code).to eq 200
    expect(data["body"]).to eq "<p>This is <em>formatted</em> in <strong>Markdown</strong>.</p>\n"
  end
end
