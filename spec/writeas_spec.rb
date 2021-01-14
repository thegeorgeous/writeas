RSpec.describe Writeas do
  let(:stubs)  { Faraday::Adapter::Test::Stubs.new }
  let(:conn)   { Faraday.new { |b| b.adapter(:test, stubs) } }
  let(:client) { Writeas::Client.new }

  it "has a version number" do
    expect(Writeas::VERSION).not_to be nil
  end
end
