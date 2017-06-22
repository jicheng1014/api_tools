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
      dict = DefaultRest.build_similar_get_request("get", "path", {a: 1}, DefaultRest.default_options)
      expect(dict[:method]).to eq "get"
      expect(dict[:url]).to eq "http://www.example.com/path?a=1"
      expect(dict[:headers][:content_type]).to eq "json"
    end
  end
end
