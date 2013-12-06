require 'spec_helper'

def app
  @app ||= Rack::Builder.app do
    use Rack::HTTPSpy
    run lambda { |env|
      # Make some requests for HTTPSpy to report
      Curl.get("www.example.com/foo")
      Curl.get("www.example.com/foo")
      Curl.get("www.example.com/bar")
      [200, {'Content-Type' => 'text/plain'}, 'pong']
    }
  end
end

def body
  last_response.body
end

describe "Reports" do
  before do
    get "/ping?_spy=true"
  end

  context "plain-text" do
    context "summary" do
      it "shows URL and method for each req" do
        expect(body).to match /^\s?GET http:\/\/www\.example\.com:80\/foo\W+2$/mi
        expect(body).to match /^\s?GET http:\/\/www\.example\.com:80\/bar\W+1$/mi
      end

      it "shows total number HTTP calls made by the app" do
        expect(body).to match /^\s+total\W+3$/mi
      end
    end
  end
end
