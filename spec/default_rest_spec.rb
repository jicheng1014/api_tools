require "spec_helper"

RSpec.describe DefaultRest do
  describe "Build dict about" do
    it "could build whole url correctly" do
      expect(DefaultRest.build_whole_url("path")).to eq "http://www.example.com/path"
      expect(DefaultRest.build_whole_url("/path")).to eq "http://www.example.com/path"

      class Tmp < DefaultRest
        def self.basic_url
          super + "/"
        end
      end
      expect(Tmp.build_whole_url("path")).to eq "http://www.example.com/path"
      expect(Tmp.build_whole_url("/path")).to eq "http://www.example.com/path"
    end

    it "could build get request" do
      dict = DefaultRest.build_similar_get_request("get", "path", { a: 1 }, DefaultRest.default_options)
      expect(dict[:method]).to eq "get"
      expect(dict[:url]).to eq "http://www.example.com/path?a=1"
      expect(dict[:headers][:content_type]).to eq :json
    end

    it "coould build post request" do
      dict = DefaultRest.build_similar_post_request("post", "path", { a: 1 }, DefaultRest.default_options)
      expect(dict[:method]).to eq "post"
      expect(dict[:url]).to eq "http://www.example.com/path"
      puts dict[:payload]
      expect(JSON.parse(dict[:payload])["a"]).to eq 1
      expect(dict[:headers][:content_type]).to eq :json
    end

    it "could add other_base_execute_option" do 
      dict = DefaultRest.build_similar_post_request("post", "path", { a: 1 }, DefaultRest.default_options.merge(other_base_execute_option: {test: "test"}))
      expect(dict[:test]).to eq "test"
    end
    
  end

  describe "request a web correctly" do
    it "could send get request" do
      stub_request(:get, "www.example.com/test").to_return(
        body: { msg: "ok" }.to_json,
        status: 200
      )
      expect(DefaultRest.get("http://www.example.com/test")[:msg]).to eq "ok"
    end

    it "raise an exception" do
      stub_request(:post, "www.example.com/test").to_return(
        body: { msg: "ok" }.to_json,
        status: 200
      )
      expect(DefaultRest.post("/test")[:msg]).to eq "ok"
      stub_request(:post, "www.example.com/test").to_return(
        body: { msg: "error" }.to_json,
        status: 403
      )
      expect(
        DefaultRest.post("/test", {a:1},
                         DefaultRest.default_options.merge(exception_with_response: false))[:response_code]
      ).to eq 403
    end
  end
end
