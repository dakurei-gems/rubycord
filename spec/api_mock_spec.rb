require "rubycord"
require "mock/api_mock"
using APIMock

describe APIMock do
  it "stores the used method" do
    Rubycord::API.raw_request(:get, [])

    expect(Rubycord::API.last_method).to eq :get
  end

  it "stores the used URL" do
    url = "https://example.com/test"
    Rubycord::API.raw_request(:get, [url])

    expect(Rubycord::API.last_url).to eq url
  end

  it "parses the stored body using JSON" do
    body = {test: 1}
    Rubycord::API.raw_request(:post, ["https://example.com/test", body.to_json])

    expect(Rubycord::API.last_body["test"]).to eq 1
  end

  it "doesn't parse the body if there is none present" do
    Rubycord::API.raw_request(:post, ["https://example.com/test", nil])

    expect(Rubycord::API.last_body).to be_nil
  end

  it "parses headers if there is no body" do
    Rubycord::API.raw_request(:post, ["https://example.com/test", nil, {a: 1, b: 2}])

    expect(Rubycord::API.last_headers[:a]).to eq 1
    expect(Rubycord::API.last_headers[:b]).to eq 2
  end

  it "parses body and headers if there is a body" do
    Rubycord::API.raw_request(:post, ["https://example.com/test", {test: 1}.to_json, {a: 1, b: 2}])

    expect(Rubycord::API.last_body["test"]).to eq 1
    expect(Rubycord::API.last_headers[:a]).to eq 1
    expect(Rubycord::API.last_headers[:b]).to eq 2
  end
end
